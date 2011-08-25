#!/usr/bin/perl -w
use strict;
################################################################################
# Standard modules with necessary subroutines
use File::Basename;
use File::Find;
use POSIX 'strftime';
use Fcntl ':mode';
use Cwd;
use Cwd 'abs_path';
use Getopt::Long;
################################################################################
# Subroutine declarations (descriptions are near definitions)
sub show_help($);
sub load_xml_file($);
sub load_config($);
sub collect_dir_data($);
sub match_regexps($$;$);
sub create_xml_report($$$);
sub create_cfg_report($$);
sub get_curr_time(;$);
sub diff_dir_data($$);
sub compare_file_object_records($$);
sub print_diff_report($$$);
################################################################################
# Global variables for messaging and self-location (if needed)
my $PROGNAME = basename($0);
my $PROGVER = "0.4 (beta)";
my $PROGPATH = abs_path(dirname($0));
################################################################################
# Mnemonics
my $FAILURE = 1;
my $SUCCESS = 0;

################################################################################
# Global variables to keep command line arguments
my $HELP = 0;
my $SAVE = 0;
my $COLLECT = 0;
my $TYPE = 0;
my $SIZE = 0;
my $MODE = 0;
my $DATE = 0;
my $TARGET = 0;
my $ALL = 0;
my @USE = ();
my @SKIP = ();
my $CONFIG = undef;
my $DIR1 = undef;
my $DIR2 = undef;
my $FORK = 0;
my $NO_CASE = 0;
my $OWNER = 0;
my $OUT_DIR = '.';
my $NLINKS = 0;
my @SUBDIR = ();
my $REPORT = undef;
my $APPEND = 0;
my $LONG_DIFF = 0;
my $PRINT_SAME = 0;
my $THRESHOLD = 0;
my $DIR_SIZE = 0;
my $XML_COMPARE = 0;
my $XML_OUT = undef;
my $KEEP_CFG = 0;
################################################################################
my %ARG_STRUCT = (
   
    'type' => \$TYPE,
    'size' => \$SIZE,
    'mode' => \$MODE,
    'date' => \$DATE,
    'target' => \$TARGET,
    'owner' => \$OWNER,
    'nlinks' => \$NLINKS,
    'all' => \$ALL,
    
    'threshold=i' => \$THRESHOLD,
    'dir_size' => \$DIR_SIZE,
    
    'use=s' => \@USE,
    'skip=s' => \@SKIP,

    'subdir=s' => \@SUBDIR,
    'report=s' => \$REPORT,
    'append' => \$APPEND,
    
    'long_diff' => \$LONG_DIFF,
    'print_same' => \$PRINT_SAME,
    
    'out_dir=s' => \$OUT_DIR,
    
    'collect' => \$COLLECT,
    'xml_out=s' => \$XML_OUT,
    'save' => \$SAVE,
    'keep_cfg' => \$KEEP_CFG,
    
    'fork' => \$FORK,
    'no_case' => \$NO_CASE,
    
    'xml_compare' => \$XML_COMPARE
    
);


################################################################################
#                        M A I N  B L O C K  B E G I N
################################################################################
# Command line argument processing
Getopt::Long::Configure('gnu_compat', 'passthrough');
# First checking for config file
Getopt::Long::GetOptions(
    'config=s' => \$CONFIG,
    'help' => \$HELP,
    'info' => \$HELP,
    'usage' => \$HELP,
    'version' => \$HELP);
show_help($SUCCESS) if ($HELP);

# Load config if it's defined
load_config($CONFIG) if (defined $CONFIG);

# Proceed to the rest of arguments (overriding config file arguments if needed)
Getopt::Long::GetOptions(%ARG_STRUCT) || show_help($FAILURE);
#===============================================================================
# Dealing with arguments (defaults, etc...)
if ($ALL) { $TYPE = 1; $SIZE = 1; $MODE = 1; $TARGET = 1;}

if ($THRESHOLD) # Validating threshold parameters
{
    $THRESHOLD = 0 if ($THRESHOLD < 0);
    $THRESHOLD = 100 if ($THRESHOLD > 100);
}

($DIR1, $DIR2) = @ARGV;

show_help(1) if (! defined $DIR1);

$DIR1 = abs_path($DIR1);

# At this point we have everything set up and now we are going to traverse the
# first directory
#===============================================================================
if ($COLLECT) # Collect mode, operating on DIR1
{
    # Collecting data and saving the report    
    create_xml_report(collect_dir_data($DIR1), $DIR1, $OUT_DIR);
    
    # Saving config arguments
    create_cfg_report($DIR1, $OUT_DIR) if ($KEEP_CFG);
    
    exit(0);
}


if ($XML_COMPARE)
{
    show_help($FAILURE) if (! defined $DIR2);
    $DIR2 = abs_path($DIR2);
    
    my ($data1, $dir1, $date1) = load_xml_file($DIR1);
    my ($data2, $dir2, $date2) = load_xml_file($DIR2);    

    # Validate which fields are available
    my $f1 = (keys %{$data1})[0];
    my $f2 = (keys %{$data2})[0];
    
    $f1 = $data1->{$f1};
    $f2 = $data2->{$f2};
    
    #  0      1        2      3      4        5      6
    # [$type, $target, $mode, $size, $owner, $mtime, $nlink]
    
    $TYPE = 0 if (! defined $f1->[0] || ! defined $f2->[0]);
    $TARGET = 0 if (! defined $f1->[1] || ! defined $f2->[1]);
    $MODE = 0 if (! defined $f1->[2] || ! defined $f2->[2]);    
    $SIZE = 0 if (! defined $f1->[3] || ! defined $f2->[3]);        
    $OWNER = 0 if (! defined $f1->[4] || ! defined $f2->[4]);            
    $DATE = 0 if (! defined $f1->[5] || ! defined $f2->[5]);            
    $NLINKS = 0 if (! defined $f1->[6] || ! defined $f2->[6]);                

    print_diff_report(diff_dir_data($data1, $data2), $REPORT, $APPEND);    
    
    exit(0);
 
    
}


# Comparison mode
$DIR2 = (defined $DIR2)?abs_path($DIR2):getcwd();

die "$PROGNAME: Error: attempt to compare directory $DIR1 with itself.\n"
    if ($DIR1 eq $DIR2);

die "$PROGNAME: Error: directory $DIR1 does not exist.\n" if (! -e $DIR1);
die "$PROGNAME: Error: directory $DIR2 does not exist.\n" if (! -e $DIR2);


my $dir_data1 = {};
my $dir_data2 = {};

if (!$FORK)
{
    $dir_data1 = collect_dir_data($DIR1);
    $dir_data2 = collect_dir_data($DIR2);
    if ($SAVE)
    {
        create_xml_report($dir_data1, $DIR1, $OUT_DIR);
        create_xml_report($dir_data2, $DIR2, $OUT_DIR);
        create_cfg_dir($DIR1, $OUT_DIR) if ($KEEP_CFG);;
        create_cfg_dir($DIR2, $OUT_DIR) if ($KEEP_CFG);
    }
    
}
else
{
    # Forking
    my $pid = fork();
    die "$PROGNAME: Error: fork(): $!.\n" if (! defined $pid);
    
    if ($pid)
    {
        # Parent
        $dir_data1 = collect_dir_data($DIR1);
        if ($SAVE)
        {
            create_xml_report($dir_data1, $DIR1, $OUT_DIR);
            create_cfg_dir($DIR1, $OUT_DIR) if ($KEEP_CFG);
        }
    }
    else
    {
        # Child
        $dir_data2 = collect_dir_data($DIR2);
        if ($SAVE)
        {
            create_xml_report($dir_data2, $DIR2, $OUT_DIR);
            create_cfg_dir($DIR2, $OUT_DIR) if ($KEEP_CFG);
        }
    }
    
    wait(); # Trivial waiting, no complicated syncronization is needed
    
}

print_diff_report(diff_dir_data($dir_data1, $dir_data2), $REPORT, $APPEND);

exit(0);
################################################################################
#                          M A I N  B L O C K  E N D
################################################################################
# Subroutines definitions
################################################################################
sub load_xml_file($)
{
    my $file = shift;
    
    open(FIN, "<$file") || die "$PROGNAME: Error: open(): $file: $!.\n";

    my %data = ();
    my $dir_date = undef;
    my $dir_name = undef;

    my $has_use = scalar @USE;
    my $has_skip = scalar @SKIP;

    
    while(<FIN>)
    {
        if (/\<report date=\"([^\"]+)\"\s+dir=\"([^\"]+)\"/)
        {
            $dir_date = $1;
            $dir_name = $2;
            next;
        }
        

        if (/\s*\<object name=\"([^\"]+)\"/)
        {
            my $name = $1;

            if ($has_use)
            {
                next if (! match_regexps($name, \@USE, $NO_CASE));                
            }

            if ($has_skip)
            {
                next if (match_regexps($name, \@SKIP, $NO_CASE));                                
            }
            
            my ($type, $target, $mode, $size, $owner, $date, $nlinks) = undef;
            
            if (/type=\"(\w+)\"/)
            {
                $type = $1;
            }

            if (/target=\"([^\"]+)\"/)
            {
                $target = $1;
            }


            
            if (/mode=\"(\d+)\"/)
            {
                $mode = $1;
            }


            if (/size=\"(\-?\d+)\"/)
            {
                $size = $1;
            }


            if (/owner=\"([^\"]+)\"/)
            {
                $owner = $1;
            }


            if (/date=\"([^\"]+)\"/)
            {
                $date = $1;
            }


            if (/nlinks=\"(\d+)\"/)
            {
                $nlinks = $1;
            }            
            
            
            $data{$name} = [$type, $target, $mode, $size, $owner, $date, $nlinks];
            
        }



        
    }
    
    close(FIN);
    
    return (\%data, $dir_name, $dir_date);

} # load_xml_file()
################################################################################
# Print a diff report to file or stdout
# In: diff data (reported by diff_dir_data )
# In: report file name (if undef, or defined but failed to open then output
# is redirected to stdout)
# In append mode (when 0, report file is overwritten, otherwise appended)
# Return: none
sub print_diff_report($$$)
{
    my $diff_data = shift;
    my $report = shift;
    my $append = shift;

    my @output = ();


    for my $obj (sort keys %{$diff_data->{DIFF}})
    {
        my $strout = "DIFF: $obj (";

        my $data = $diff_data->{DIFF}->{$obj};
        
        my @diff_criterias = ();
        
        if ($TYPE && $data->[0]->[0])
        {
            push @diff_criterias, (!$LONG_DIFF)?'type':"type:$data->[0]->[1]<>$data->[0]->[2]";
            
        }
       
        if ($TARGET && $data->[1]->[0])
        {
            push @diff_criterias, (!$LONG_DIFF)?'target':"target:$data->[1]->[1]<>$data->[1]->[2]";
            
        }
        
        if ($MODE && $data->[2]->[0])
        {
            push @diff_criterias, (!$LONG_DIFF)?'mode':"mode:$data->[2]->[1]<>$data->[2]->[2]";
        }
        
        if ($SIZE && $data->[3]->[0])
        {
            push @diff_criterias, (!$LONG_DIFF)?'size':"size:$data->[3]->[1]<>$data->[3]->[2]";
        }
        
        if ($OWNER && $data->[4]->[0])
        {
            push @diff_criterias, (!$LONG_DIFF)?'owner':"owner:$data->[4]->[1]<>$data->[4]->[2]";
        }
        
        if ($DATE && $data->[5]->[0])
        {
            push @diff_criterias, (!$LONG_DIFF)?'date':"date:$data->[5]->[1]<>$data->[5]->[2]";
        }
        
        if ($NLINKS && $data->[6]->[0])
        {
            push @diff_criterias, (!$LONG_DIFF)?'nlinks':"nlinks:$data->[6]->[1]<>$data->[6]->[2]";
        }
         
        
        
        $strout .= join(',', @diff_criterias);
        
        $strout .= ")";
       
        push @output, $strout;
        
    }

    my @MODES = ('DELETED', 'ADDED');
    push @MODES, 'SAME' if ($PRINT_SAME);

    for my $mode (@MODES)
    {
        for my $obj (sort keys %{$diff_data->{$mode}})
        {
            
            my $data = $diff_data->{$mode}->{$obj};
            
            my $strout = "$mode: $obj";

            #  0      1        2      3      4        5      6
            # [$type, $target, $mode, $size, $owner, $mtime, $nlink]
           
            $strout .= " TYPE=$data->[0]" if ($TYPE);
            $strout .= " TARGET=$data->[1]" if ($TARGET);
            $strout .= " MODE=$data->[2]" if ($MODE);
            $strout .= " SIZE=$data->[3]" if ($SIZE);
            $strout .= " OWNER=$data->[4]"if ($OWNER);
            $strout .= " DATE=$data->[5]" if ($DATE);
            $strout .= " NLINKS=$data->[6]" if ($NLINKS);
            
            push @output, $strout;
            
        }
        
    }


    if (! scalar @output)
    {
        print "$PROGNAME: Info: No differences detected. No report is generated.\n";
        return;
    }

    my $openmode = ($append)?'>>':'>';
    my $to_file = 0;
    my $fhandle = undef;
    if (defined $report)
    {
        if (!open($fhandle, "$openmode$report"))
        {
            warn "$PROGNAME: Warning: open(): $report: $!.\n";
            warn "$PROGNAME: Warning: Output will be redirected to stdout.\n";
            $fhandle = *STDOUT;
        }
        else
        {
            $to_file = 1;
        }
    }
    else
    {
        $fhandle = *STDOUT;
    }

    for (@output) { print $fhandle "$_\n";}

    if ($to_file)
    {
        close($fhandle) || warn "$PROGNAME: Warning: close(): $report: $!.\n";
    }
    
}
#===============================================================================
# Compare two directory data and returns a hash reference of diff structure
# In: dir_data hashref
# In: dir_data hashref
# Return: diff_data hashref
sub diff_dir_data($$)
{
    my $data1 = shift;
    my $data2 = shift;
    
    my %diff_data = (ADDED => {}, DELETED => {}, DIFF => {}, SAME => {});
    
    for my $d1 (keys %{$data1})
    {
        if (exists $data2->{$d1})
        {
            
            my $compare_result = compare_file_object_records($data1->{$d1}, $data2->{$d1});
            
            my $has_diff = $compare_result->[0];
            
            if (! $has_diff)
            {
                $diff_data{SAME}->{$d1} = $data1->{$d1};
            }
            else
            {
                $diff_data{DIFF}->{$d1} = $compare_result->[1];
            }


            delete $data2->{$d1};
        }
        else
        {
            $diff_data{DELETED}->{$d1} = $data1->{$d1};
        }
        
        delete $data1->{$d1};
        
    }
    
    for my $d2 (keys %{$data2})
    {
        $diff_data{ADDED}->{$d2} = $data2->{$d2};
        delete $data2->{$d2};
    }
        
    return \%diff_data;
    
} # diff_dir_data()
#===============================================================================
# Compare two file object records
# Compares two object related datasets and returns a complicated list reference
# If no diffs, then [0] is returns (listref!)
# Othewise: it's [1, <listref>], where listref consists of listrefs like these:
# # [1, <first_value>, <new_value>] if there are diffs
# [0, <first_value> ] if no diffs
#
sub compare_file_object_records($$)
{
    my $data1 = shift;
    my $data2 = shift;
    
    return [0] if (! defined $data1 || ! defined $data2);
    return [0] if (! scalar @{$data1} && ! scalar @{$data2});
    
    #  0      1        2      3      4       5       6
    # [$type, $target, $mode, $size, $owner, $mtime, $nlink]
    
    my @diff_data = ();
    my $has_diff = 0;

    if ($TYPE)
    {
        if ($data1->[0] ne $data2->[0])
        {
            ++$has_diff;
            push @diff_data, [1, $data1->[0], $data2->[0]];            
        }
        else
        {
            push @diff_data, [0, $data1->[0]];
        }
    }
    else
    {
        push @diff_data, [0, $data1->[0]];
    }
    
    if ($TARGET)
    {
        if ($data1->[1] ne $data2->[1])
        {
            ++$has_diff;
            push @diff_data, [1, $data1->[1], $data2->[1]];            
        }
        else
        {
            push @diff_data, [0, $data1->[1]];
        }
    }
    else
    {
        push @diff_data, [0, $data1->[1]];
    }


    if ($MODE)
    {
        if ($data1->[2] != $data2->[2])
        {
            ++$has_diff;
            push @diff_data, [1, $data1->[2], $data2->[2]];            
        }
        else
        {
            push @diff_data, [0, $data1->[2]];
        }
    }
    else
    {
        push @diff_data, [0, $data1->[2]];
    }

    if ($SIZE)
    {
        
       
        my $delta = 0;
        if ($data1->[3] != $data2->[3])
        {
       
            my ($size1, $size2) = sort($data1->[3], $data2->[3]);

            # If second size is 0, then we have 2 0-sized files, delta is 0, otherwise:
            if ($size2) 
            {
                if (!$size1) # if first size is 0, and the second is not, then
                {           # delta is definitely 100%
                    $delta = 100;
                }
                else
                {
                    $delta = 100 - (100 * $size1)/$size2;
                }
            }
        }
        
        if ($delta > $THRESHOLD)
        {
            ++$has_diff;
            push @diff_data, [1, $data1->[3], $data2->[3]];            
        }
        else
        {
            push @diff_data, [0, $data1->[3]];
        }
    }
    else
    {
        push @diff_data, [0, $data1->[3]];
    }


    if ($OWNER)
    {
        if ($data1->[4] ne $data2->[4])
        {
            ++$has_diff;
            push @diff_data, [1, $data1->[4], $data2->[4]];            
        }
        else
        {
            push @diff_data, [0, $data1->[4]];
        }
    }
    else
    {
        push @diff_data, [0, $data1->[4], $data1->[5]];
    }


    if ($DATE)
    {
  
        
        if ($data1->[5] ne $data2->[5])
        {
            ++$has_diff;
            push @diff_data, [1, $data1->[5], $data2->[5]];            
        }
        else
        {
            push @diff_data, [0, $data1->[5]];
        }
        
    }
    else
    {
        push @diff_data, [0, $data1->[5]];        
    }
    

    if ($NLINKS)
    {
        if ($data1->[6] ne $data2->[6])
        {
            ++$has_diff;
            push @diff_data, [1, $data1->[6], $data2->[6]];            
        }
        else
        {
            push @diff_data, [0, $data1->[6]];
        }        
    }
    else
    {
        push @diff_data, [0, $data1->[6]];        
    }
    
    return ($has_diff)?[1, \@diff_data]:[0];
    
} # compare_file_object_records()
#===============================================================================
# Print config data to cfg file for further re-usage
# In: full directory name (used in report creation)
# In: Second directory
# In: Data output directory
# Return: none
# Note(s): dies on IO error
sub create_cfg_report($$)
{
    my $indir = shift;
    my $outdir = shift;
    
      my $date = get_curr_time();
    my $outfile = undef;
    
    if (defined $XML_OUT)
    {
        $outfile = $XML_OUT . '.cfg';
    }
    else
    {
       $outfile = $indir; 
       $outfile =~ s/\//_/g;
       $outfile = "$outdir/$outfile.$date.cfg";
    }
    

   
    open(FOUT, ">$outfile") || die "$PROGNAME: Error: open(): $outfile: $!.\n";    
    
    print FOUT "# Config file for report generated on $date\n";
    print FOUT "# For directory $indir\n";
    
    # Dumping the value   
    for my $key (sort keys %ARG_STRUCT)
    {
        my $arg_name = $key;
        my $has_value = 0;
        if ($key =~ /^(\w+)=\w$/)
        {
            $arg_name = $1;
            $has_value = 1;
        }
        
        if (! $has_value)
        {
            if (${$ARG_STRUCT{$key}})
            {
                print FOUT "--" . "$arg_name\n";
            }
            
            next;
        }
        
        if (ref($ARG_STRUCT{$key}) eq 'ARRAY')
        {
            for my $val (@{$ARG_STRUCT{$key}})
            {
                print FOUT "--" . "$arg_name=$val\n" if (defined $val);
            }
        }
        else
        {
            print FOUT "--" . "$arg_name=" . ${$ARG_STRUCT{$key}} . "\n"
                if (defined ${$ARG_STRUCT{$key}});
        }
        
    }
    
    
    print FOUT "# End of config file\n";    
    close(FOUT) || warn "$PROGNAME: Warning: close(): $outfile: $!.\n";
    
    
} # create_cfg_report()
#===============================================================================
# Print directory data to an xml file
# In: directory data (as hashref)
# In: full directory name (used in report creation)
# In: directory to store saved XML file (default is ., ignored when save is 0)
# Return: none
# Note(s): dies on IO error
sub create_xml_report($$$)
{
    my $data = shift;
    my $indir = shift;
    my $outdir = shift;
    
    
    my $date = get_curr_time();
    my $outfile = undef;
    
    if (defined $XML_OUT)
    {
        $outfile = $XML_OUT;
    }
    else
    {
       $outfile = $indir; 
       $outfile =~ s/\//_/g;
       $outfile = "$outdir/$outfile.$date.xml";
    }
    
    
    open(FOUT, ">$outfile") || die "$PROGNAME: Error: open(): $outfile: $!.\n";

    # Printing XML header
    print FOUT "<?xml version=\"1.0\"?>\n";
    print FOUT "<report date=\"$date\" dir=\"$indir\">\n";
    
    for my $obj (sort keys %{$data})
    {
        my $outstr = "<object name=\"$obj\"";
        
        my @details = @{$data->{$obj}};

        if ($TYPE)
        {
            $outstr .= " type=\"$details[0]\"";
        }

        if ($TARGET)
        {
            my $trg_val = ($details[0] eq 's')?$details[1]:'none';
            $outstr .= " target=\"$trg_val\"";            
        }

        if ($MODE)
        {
            $outstr .= " mode=\"$details[2]\"";
        }

        if ($SIZE)
        {
            $outstr .= " size=\"$details[3]\"";
        }
        
        if ($OWNER)
        {
            $outstr .= " owner=\"$details[4]\"";
        }

        if ($DATE)
        {
            my $time = $details[5];
            $outstr .= " date=\"$time\"";
        }
        
        if ($NLINKS)
        {
            $outstr .= " nlinks=\"$details[6]\"";
        }        
        
        
        print FOUT "$outstr/>\n";
        
    }
    
    print FOUT "</report>\n";
    
    
    close(FOUT) || warn "$PROGNAME: Warning: close(): $outfile: $!.\n";
    
} # create_xml_report()
#===============================================================================
# Returns formatted string with current date/time
# accepts optionally time (seconds since epoque), if missed - localtime is used
sub get_curr_time(;$)
{
   my $time = shift;
   
   my @mtime = (defined $time)?localtime($time):localtime;
   
   
   return POSIX::strftime("%Y-%m-%d_%H.%M.%S", @mtime); 
    
} # get_curr_time()
#===============================================================================
# Collect directory data and returns a hash reference
# In: absolute path to directory
# Return: hash reference of a type
# <path> => [file data]
# If $NEED_STAT is 0, then these fields are set to undef
# If file is a symlink and $TARGET is 1 then target is link target, undef other
# wise. The script dies on first error if $DIE_ON_ERROR is set to 1
sub collect_dir_data($)
{
    my $dir = shift;

    my %dir_data = ();


    my $has_use = scalar(@USE);
    my $has_skip = scalar(@SKIP);
    
    my $curr_dir = getcwd();

    my @sub_dirs = ();
    
    if (scalar @SUBDIR)
    {
        @sub_dirs = sort map {"$dir/$_"} @SUBDIR;
    }
    else
    {
        @sub_dirs = ($dir);
    }

    my $dir_name_len = length($dir);    
    
    for my $d (@sub_dirs)
    {

        if (! -e $d)
        {
            warn "$PROGNAME: Error: $d does not exist. Skipped.\n";
            next;
        }



        if (!chdir ($d))
        {
            warn "$PROGNAME: Error: chdir(): $d: $!. Data collection skipped.\n";
            next;
        }


        File::Find::find(
            sub{
               
                return if ($File::Find::name eq $d);
                
                # If we have 'use' list, then proceed only if file path matches
                if ($has_use)
                {
                    return if (! match_regexps($File::Find::name, \@USE, $NO_CASE));
                }
    
                # If we have 'skip' list, then proceed only if file path does not match
                if ($has_skip)
                {
                    return if (  match_regexps($File::Find::name, \@SKIP, $NO_CASE));
                }
    
                # If we need to verify targets for links - we do that here
                my $target = 'none';
                my $has_errors = 0;

                my $is_dir = (-d $File::Find::name)?1:0;
                my $is_file = (-f $File::Find::name)?1:0;
                my $is_link = (-l $File::Find::name)?1:0;


                my @stat_info = ($is_link)?lstat($File::Find::name):stat($File::Find::name);
                if ($#stat_info == -1)
                {
                    warn "$PROGNAME: Warning: stat(): $File::Find::name: $!.\n";
                    $has_errors = 1;
                }
    
                if ($is_link)
                {
                    
                    $target = readlink($File::Find::name);
                    if (! defined $target)
                    {
                        warn "$PROGNAME: Warning: readlink(): $File::Find::name: $!.\n";
                        $has_errors = 1;
                    }
                }
    
    
                    
                # No need to proceed if there was an error with readlink or stat
                return if ($has_errors);
                
                # Collecting the attributes
                my $mode = sprintf("%o", S_IMODE($stat_info[2]));
                my $size = $stat_info[7];
                my $nlink = $stat_info[3];
                my $uid = scalar getpwuid($stat_info[4]);
                $uid = $stat_info[4] if (! defined $uid);
                my $gid = scalar getgrgid($stat_info[5]);
                $gid = $stat_info[5] if (! defined $gid);
                my $owner = "$uid\@$gid";
                my $mtime = get_curr_time($stat_info[9]);
                
                my $type = 'o';
                
                if ($is_dir)
                {
                    $type = 'd';
                }elsif ($is_link)
                {
                    $type = 's';
                }
                elsif ($is_file)
                {
                    $type = 'f';
                }
                
                $size = -1 if ($type eq 'd' && !$DIR_SIZE);
    
                my $key = substr($File::Find::name, $dir_name_len + 1);
                # Indexes          0       1        2      3      4      5       6
                $dir_data{$key} = [$type, $target, $mode, $size, $owner, $mtime, $nlink];
    
                
            }, getcwd());
    
        }
    
    chdir ($curr_dir) || warn "$PROGNAME: Warning: chdir(): $curr_dir: $!.\n";

    return \%dir_data;
   
} # collect_dir_data()
#===============================================================================
# Returns 1 if line matches any of given regexps from list reference
# In: line to match
# In: list reference with regular expression(s)
# In: case insensitive when 1, case sensitive otherwise (default: 0)
# Return: 1 if there was a matching, 0 otherwise
sub match_regexps($$;$)
{
    my $line = shift;
    my $regexps = shift;
    
    my $no_case = shift;
    $no_case = 0 if (! defined $no_case);
    
    
    for my $r (@{$regexps})
    {
        my $res = ($no_case)?$line=~/$r/i:$line=~/$r/;
        
        return 1 if ($res);
    }
    
    return 0;
    
} # match_regexps()
#===============================================================================
# parses config file and fills the ARG_STRUCT global structure
# In: path to config file
# Return: undef
# Note(s): dies on I/O error, warns about incorrect syntax
sub load_config($)
{
    my $file = shift;
    
    open(FIN, "<$file") || die "$PROGNAME: Error: open(): $file: $!.\n";
    
    # Forming a temporary hash to validate the lines in config file
    my %validator = ();
    for my $arg (keys %ARG_STRUCT)
    {
        my ($a, $v) = split(/\s*=\s*/, $arg);
        # first element in listref shows do we need value for argument or not
        $validator{$a} = (defined $v)?[1, $arg]:[0, $arg];
    }
    
    
    my $line_no = 0;   
    while(<FIN>) # File parser loop begin
    {
        ++$line_no;
        
        # Skipping empty lines
        next if (/^\s*$/);
        # Skipping comment lines (starting with #)
        next if (/^\s*#/);
        
        # Removing leading and trailing spaces if any (no chomp because
        # we may have more than one space character in tail)
        s/^\s+//; s/\s+$//;
        
        my ($arg, $val) = split(/\s*=\s*/, $_);
        
        # Eliminating leading dashes
        $arg =~ s/^\-+//;
    
        # Converting to lower case
        $arg = lc $arg;
        
        # Checking for syntax
        
        if (! exists $validator{$arg})
        {
            warn "$PROGNAME: Warning: $file:$line_no: unsupported argument $arg. Skipped.\n";
            next;
        }

        if ($validator{$arg}->[0]) # Does argument require a value?
        {
            if (! defined $val)
            {
                warn "$PROGNAME: Warning: $file:$line_no: argument $arg requires a value. Argument is ignored.\n";
                next;
            }
            
            
        }
        else # Is it a non-value argument?
        {
            if (defined $val)
            {
                warn "$PROGNAME: Warning: $file:$line_no: argument $arg does not require value. Value is ignored.\n";
            }

            $val = 1; # flag type value, presence or argument means yes
        }

        my $key = $validator{$arg}->[1];
        
        # At this point we are going to store the value by reference
        if (ref($ARG_STRUCT{$key}) eq 'ARRAY')
        {
            push @{$ARG_STRUCT{$key}}, $val;
        }
        else
        {
            
            ${$ARG_STRUCT{$key}} = $val;
        }
        
        
        
        
        
    } # File parser loop end
    
    close(FIN) || warn "$PROGNAME: Warning: close(): $file: $!.\n";
    
    
} # load_config()
#===============================================================================
# Show help message and exit with given status
# In: exit code (integer)
# Return: none
# Note(s): function exits program execution
sub show_help($)
{
    my $status = shift;

print "Todo...

$PROGNAME $PROGVER
Compares two directory trees.

usage: $PROGNAME --<help|info|usage|version>
       $PROGNAME [--config=<path>]  [--report=<path>] [--long_diff] [--print_same]
       [--collect] [--save] [--xml] [--all] [--type] [--size] [--mode]
       [--out_dir=<dir>] [--append] [--target] [--owner] [--nlinks] [--date]
       [--fork] [--no_case]
       [--use=<regexp1> [... --use=<regexpN>]]
       [--skip=<regexp1> [... --skip=<regexpN>]]
       [--subdir=<subdir1> [... --subdir=<subdirN>]] <path1> [<path2>]


path1             First directory
path2             Second directory (if omitted current directory is used)
                  Note: second directory is silently ignored if --collect is on
                  
                  Note: when --xml_compare, then path1 and path2 should be 2
                  XML files previously created by build_diff.pl --collect


--config=<path>  Load configuration from given file
                 Note: command line arguments override config file values
                 Command line has argument[=value syntax] (argument is the
                 same gnu-style command line argument), full line comments
                 starting with hash (#) are allowed, empty lines are ignored,
                 arguments are case insensitive.
                 
                 help, info, usage, version and config arguments should NOT
                 appear in config file (otherwise they will be reported as
                 faulty and skipped)
                 

--type           Compare (report) file types
--size           Report object sizes
                 Note: directory sizes do not participate in size comparison.
                 They are masked by -1 number.
                 
--dir_size       Make directory sizes participate in size comparison. Meaningful
                 only in conjunction with --size.
--threshold=<n>  Threshold percentage (0-100, default: 0) to treat as difference
                 i.e. if size difference > n\% than objects are treated
                 as different, otherwise they are treated as matching. Used only
                 in conjunction with --size.

                 
--mode           Compare (report) file permission modes
--target         Compare (report) targets for symbolic links

--nlinks         Compare (report) links to file
--date           Compare (report) file last modification dates
--owner          Compare (report) file owner/group info

--all            Compare (report) types,sizes,modes,targets (date,owner,nlinks
                 are NOT used)

--use=<regexp>   Consider ONLY the paths matching given regexp
--skip=<regexp>  Skip tha paths matching given regexp
                 Note: these two arguments allow multiple appearance
                       order of appearance matters, first 'use', then 'skip'

--report=<path>  File to store diff report (default is stdio)
                 Note: ignored in --collect mode.
--append         Append to diff report file if exists (default: overwrite)
                 Note: applicable only if not --collect and --report is used
                 
--long_diff      Print details on differing objects
--print_same     Output for matching objects
                 Note: applicable only if not --collect

--subdir=<path>  Relative path to subdirectories to compare (collect)

--collect        Only collect directory data (no differing)
--xml_out=<path> Save collected directory data under given name
                 Note: applicable only if --collect, when missed for --collect,
                 then xml file is saved as <converted_dir_name_date.xml>
                 
--save           Save data in file(s) (name: <converted_dir_name_date.xml)
                 Note: in collect mode --save is activated automatically

--keep_cfg       Keep configuration used to collect/compare data

--out_dir=<path> Directory to save directory data (used only with --save)

--xml_compare    Load and compare two XML files previously generated by
                 build_diff --collect


--fork           Fork when collecting information about two dirs
                 Note: this argument is ignored when --collect

--no_case        Match to regexps with case ignored
                 Note: applied only when --use and/or --skip are used


--help
--info
--usage
--version    Show this help screen and exit


\n";    
    
    exit($status);
    
} # show_help()
