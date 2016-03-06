# pdf-two-on-one
Small windows / Batch hack to cut two PDF files halfways and join them into one page using ImageMagick.

## The problem
You are working with a program and want to print the results. Unfortunately, you cannot print all the results at once, but the program gives you two prints. Each of the prints is one page, filled less than 50%.

![A page, half filled with content A](https://raw.githubusercontent.com/bennaux/pdf-two-on-one/master/readme-images/A.png) 
![A page, half filled with content B](https://raw.githubusercontent.com/bennaux/pdf-two-on-one/master/readme-images/B.png)

## The solution that this script offers
It takes two one-page PDF files (from CLI argument or from drag'n'drop) and cuts each of them at half page height. After that, both upper parts are merged into one single one-page PDF document.

![A page, filled with content A and B](https://raw.githubusercontent.com/bennaux/pdf-two-on-one/master/readme-images/aAndB.png)

It uses ImageMagick, so the PDFs will be **rasterized** during this process.

The resulting PDF will be placed at a configurable folder, its name will be `YYYY-MM-DD-##`, where `YYYY-MM-DD` depicts the current date. At the end there's a two-digit number that will be chosen as low as possible without overwriting anything.

### Requirements
* Both pages have to be in PDF format, so you should just print them with a PDF printer, one after one.
* The script uses **ImageMagick** and **wmic**.

### Setup
0. Read the code to make sure I do not want to harm you and did not make a mistake (yes, this script is written for those who know what they are doing).
0. Copy the two `.bat` files somewhere you find them again and won't delete them by accident. 
0. Rename the settings template file from `twoOnOne_configuration-TEMPLATE.bat` to `twoOnOne_configuration.bat` and fill in the needed values. **Do not type blanks around the `=`!**:  
`imConvert`: The path to ImageMagick's `convert.exe`, including `convert.exe` itself.  
`imResolution`: The resolution the PDF files will be rasterized, given in dpi. A reasonable value is `300x300`.  
`outputPath`: The path the resulting file will be put into.  
`tempImagePath`: A path where the script can place its temporary files without taking care if it is overwriting anything.
0. Make a link to the script `twoOnOne.bat`, so that you can drop files onto it. **Make sure the working dir of the link is the directory where the script lies, so that it can find the configuration file**.

### Workflow
0. Work and create the first result.
0. Print it with a PDF printer into a single-page PDF file.
0. Repeat this to have the second PDF as well.
0. Mark the two files and drop them onto the link to this script.
0. A cmd window opens, displaying ImageMagick messages and copying messages.
0. The resulting PDF will be opened in the default PDF viewer.
0. The cmd window closes after a key press into it.

## Notes
* If you want the cmd window to close automatically, you can remove the `PAUSE` command from the script.
* Three temporary files are created at the `tempImagePath`: `image1.pdf`, `image2.pdf` and `image3.pdf`. The last one contains the result, the first ones the cut images. The files will not be deleted, since they will get overwritten each time the script runs.

## Attention
Although it is commented quite well, this script is a quick-and-dirty solution that has been written in a very short period of time to be used by myself. It has **not** been tested in-depth to confirm that it wouldn't destroy valuable data. You have been warned.