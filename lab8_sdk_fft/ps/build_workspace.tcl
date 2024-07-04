# Get a list of .hdf files in the current directory
set hdf_files [glob -nocomplain *.hdf]

# Check the number of .hdf files found
set file_count [llength $hdf_files]

if {$file_count == 1} {
    # Exactly one .hdf file found, get its name
    set hdf_file_full_name [lindex $hdf_files 0]
    set hdf_file_base_name [file rootname $hdf_file_full_name]
} else {
    # None or more than one .hdf files found, stop the script
    if {$file_count == 0} {
        puts "Error: No .hdf files found in the directory. Export it from 'pl' project using Vivado."
    } else {
        puts "Error: Multiple .hdf files found in the directory. Use SDK GUI to rebuild the workspace."
    }
    exit 1
}

# set workspace
sdk setws .

# create hardware project
sdk createhw -name "${hdf_file_base_name}_hw_platform_0" -hwspec $hdf_file_full_name

# import projects
sdk importprojects .

# launch sdk
exec xsdk -workspace .
