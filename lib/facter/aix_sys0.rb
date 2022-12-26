#
#  FACT(S):     aix_sys0
#
#  PURPOSE:     This custom fact returns a hash of "lsattr -l sys0 -H -E" 
#		output with name->value.
#
#  RETURNS:     (hash)
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        March 16, 2021
#
#  NOTES:       Myriad names and acronyms are trademarked or copyrighted by IBM
#               including but not limited to IBM, PowerHA, AIX, RSCT (Reliable,
#               Scalable Cluster Technology), and CAA (Cluster-Aware AIX).  All
#               rights to such names and acronyms belong with their owner.
#
#		NEVER FORGET!  "\n" and '\n' are not the same in Ruby!
#
#-------------------------------------------------------------------------------
#
#  LAST MOD:    (never)
#
#  MODIFICATION HISTORY:
#
#       (none)
#
#-------------------------------------------------------------------------------
#
Facter.add(:aix_sys0) do
    #  This only applies to the AIX operating system
    confine :osfamily => 'AIX'

    #  Define an empty hash to return
    l_aixSys0 = {}

    #  Do the work
    setcode do
        #  Run the command to look at the system pseudo-device settings
        l_lines = Facter::Util::Resolution.exec('/usr/sbin/lsattr -l sys0 -H -E 2>/dev/null')

        #  Loop over the lines that were returned
        l_lines && l_lines.split("\n").each do |l_oneLine|
            #  Skip the header and blank lines
            next if ((l_oneLine =~ /^attribute /) or (l_oneLine =~ /^$/))

            #  Strip leading and trailing whitespace and split on any whitespace
            l_list = l_oneLine.strip().split()

            #  Stash the data in the hash as name -> value
            l_aixSys0[l_list[0]] = l_list[1]
        end

        #  Implicitly return the contents of the variable
        l_aixSys0
    end
end
