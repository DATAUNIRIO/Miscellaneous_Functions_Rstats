

# install.packages("devtools")
devtools::install_github("pridiltal/staplr")

library(staplr)
# Merge multiple PDF files into one
staple_pdf()

# This command prompts the user to select the file interactively. 
# Remove page 2 and 3 from the selected file.
remove_pages(rmpages = c(2,3))

# This function selects pages from a file;
select_pages(selpages = c(1,3))

# This function splits a single input PDF document into individual pages
split_pdf()

# This function writes renamed files back to directory
#if the directory contains 3 PDF files
rename_files(new_names = paste("file",1:3))

# These functions are to fill out pdf forms
get_fields() 
set_fields()
# This includes 2 external functions `get_fields` and `set_fields` 
# and files to use as examples.
# This is what the example file looks like

# If you get path to this file by
pdfFile = system.file('testForm.pdf',package = 'staplr')

# And do
fields = get_fields(pdfFile)
# You'll get a list of fields that the pdf contains 
# along with some additional information about the fields.

# You make modifications in any of the fields by
fields$TextField1$value = 'this is text'
set_fields(pdfFile, 'newFile.pdf', fields)

# This will create a filled pdf file


