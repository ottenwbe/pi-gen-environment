# Layers
* __Environment__ to run in (e.g., AWS or VAGRANT) hosts a __workspace__
* __Workspace__ comprises all files needed to __modify__ and __build__ a RasPi image
    * The workspace is populated by default from a for of the official raspbian build tool
* __Modification__ steps include adding stages to the build tool 
* __Build__ steps include building one or more images

# Build Steps

1. Environment creation and selection
1. Environment startup
1. Workspace creation 
1. Load sources to workspace
1. Load modification sources
1. Modify sources in workspace
1. Build pi image
1. Ship pi image to destination
1. Delete Environment

# Modes
1. Prepare and Run
1. Start and Adapt