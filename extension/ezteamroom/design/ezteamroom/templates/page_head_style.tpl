{ezcss_load( array( 'yui/fonts/fonts-min.css', 
                    'core.css', 
                    'debug.css', 
                    'teamroom.css', 
                    ezini( 'StylesheetSettings', 'CSSFileList', 'design.ini' ) ) ) }

<link rel="stylesheet" type="text/css" href={"stylesheets/print.css"|ezdesign} media="print" />
<!-- IE conditional comments; for bug fixes for different IE versions -->
<!--[if IE 5]> <style type="text/css"> @import url({"stylesheets/browsers/ie5.css"|ezdesign(no)}); </style> <![endif]-->
<!--[if IE 6]> <style type="text/css"> @import url({"stylesheets/browsers/ie6.css"|ezdesign(no)}); </style> <![endif]-->
<!--[if IE 7]> <style type="text/css"> @import url({"stylesheets/browsers/ie7.css"|ezdesign(no)}); </style> <![endif]-->