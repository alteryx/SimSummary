# Simulation Summary

<img src="SimSummaryIcon.png" width=48 height=48></img> 

This repo contains the **Simulation Summary** tool. Shown below is a brief description of the contents. 

| File                               | Description                                       |
|------------------------------------|---------------------------------------------------| 
| SimSummaryConfig.xml               | Configuration for plugin (auto generated)         |
| SimSummaryGui.html                 | Gui for plugin (auto generated)                   |
| SimSummaryIcon.png                 | Icon for plugin                                   |
| Gui/layout.html                    | Layout for organizing widgets in Gui.html         |
| Supporting_Macros/SimSummary.yxmc | Macro backend                                     |
| Supporting_Macros/SimSummary1.R   | R code in the macro                               |

### Installation

1. Download https://github.com/alteryx/SimSummary/archive/master.zip.
2. Rename `SimSummary-master.zip` to `SimSummary.yxi`.
3. Open in Alteryx to complete installation.

### Development

Clone this repo using RStudio or the command line. Use branches to work on features and bug fixes. Commit often. Send a PR to the upstream repo to merge your changes back in. Make sure to sync your clone with the upstream repo before sending a PR, so that merge conflicts are avoided.

The `source` files that will be modified directly include

1. Supporting_Macros/SimSummary.yxmc (backend)
2. Supporting_Macros/SimSummary1.R   (backend)
3. Gui/layout.html (ui)

Whenever you manipulate one of these source files, you can run the `buildPlugin()` function shown below to update the plugin and install it in Alteryx. Make sure to set `options(alterx.path = <path to alteryx directory>)`  before running the build.

```r
library(AlteryxRhelper)
options(alteryx.path = <path to alteryx>)
buildPlugin <- function(pluginDir = "."){
  withr::with_dir(file.path(pluginDir, "Supporting_Macros"), 
    insertRcode("SimSummary.yxmc", "SimSummary1.R")
  )
  createPluginFromMacro(pluginDir, layout = TRUE)
  updateHtmlPlugin(pluginDir)
}
```

