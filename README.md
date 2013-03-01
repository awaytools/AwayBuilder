# Away Builder

Flex SDK: 4.6
AIR SDK: 3.5

## awaybuilder-core
Flex library project that contains shared sources for all Away Builder applications.
Project type: Flex library for desktop

### Project file structure:
_src/_ - main source directory
_libs/_ - library directory with .swc files.

### Files to include in the library:
* __src/assets/*__
* __src/defaults.css__
(in Flash Builder: Project Properties -> Flex Library Build Path -> Assets -> select All)

## awaybuilder-desktop
Project must be set up as Flex AIR project

### Project file structure:
_src/_ - main source directory
_src/AwayBuilderApplication.mxml_ - main application
_src/AwayBuilderApplication-app.xml_ - AIR application descriptor

_awaybuilder-core_ project must be added as linked library
