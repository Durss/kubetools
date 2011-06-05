@echo                               ######################
@echo                               # Building Font file #
@echo                               ######################
@echo                                 Please wait while
@echo                                compiling your font
@echo                                     into SWF.
@echo.
@echo.
@echo.
@echo                                     #       #
@echo                                     #       #
@echo                                     #       #
@echo                                 #               #
@echo                                  ##           ##
@echo                                    ###########
@echo.
@echo.
@echo.

"C:\Program Files\Eclipse\3.4\plugins\flex_sdk_3.3.0.4852\bin\mxmlc.exe" -file-specs "LatinFonts.as" -output "../../deploy/fonts/Fonts.swf" -default-size 250 400 -default-background-color 0xFFFFFF
IF ERRORLEVEL 3 Pause
