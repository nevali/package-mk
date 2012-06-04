## Packaging rules and variables specific to Darwin and Mac OS X

OPSYS_VER = $(shell uname -r)
OPSYS_RELEASE = $(shell uname -r | cut -f1 -d.)

DEFAULT_PLATFORM = MacOSX
DEFAULT_SDK_MacOSX = MacOSX10.6
DEFAULT_SDK_iPhoneOS = iPhoneOS5.1

# Set BUILD_ARCH to the build architecture; defaults to x86_64
# on Darwin 10 and 11

ifeq ($(OPSYS_RELEASE),11)
BUILD_ARCH ?= x86_64
endif
ifeq ($(OPSYS_RELEASE),10)
BUILD_ARCH ?= x86_64
endif
BUILD_ARCH ?= $(shell arch)
export BUILD_ARCH

## Set PLATFORM_NAME
PLATFORM_NAME ?= $(DEFAULT_PLATFORM)
export PLATFORM_NAME

## Set SDK_NAME
SDK_NAME ?= $(DEFAULT_SDK_$(PLATFORM_NAME))
export SDK_NAME

## CURRENT_ARCH defaults to armv7 on iPhoneOS, $(BUILD_ARCH) otherwise
ifeq ($(PLATFORM_NAME),iPhoneOS)
ARCH ?= armv7
else
ARCH ?= $(BUILD_ARCH)
endif
CURRENT_ARCH = $(ARCH)
export ARCH

## Set BUILD_TRIPLET
BUILD_TRIPLET ?= $(BUILD_ARCH)-unknown-darwin$(OPSYS_RELEASE)

## Set HOST_TRIPLET
HOST_TRIPLET ?= $(CURRENT_ARCH)-unknown-darwin$(OPSYS_RELEASE)

## Set DEVELOPER_DIR
DEVELOPER_DIR ?= $(shell test -d /Developer && echo /Developer)
## Set DEVELOPER_APPLICATIONS_DIR
DEVELOPER_APPLICATIONS_DIR ?= $(DEVELOPER_DIR)/Applications
## Set DEVELOPER_SDK_DIR
DEVELOPER_SDK_DIR ?= $(DEVELOPER_DIR)/SDKs
## Set DEVELOPER_SDK_DIR
DEVELOPER_PLATFORM_DIR ?= $(DEVELOPER_DIR)/Platforms

## Set XCODE_APP
XCODE_APP ?= $(shell test -d $(DEVELOPER_APPLICATIONS_DIR)/Xcode.app && echo $(DEVELOPER_APPLICATIONS_DIR)/Xcode.app)

## Set PLATFORM_DIR
# If the platform exists within $(XCODE_APP)/Contents/Developer/Platforms, use
# that path
ifneq ($(XCODE_APP),)
PLATFORM_DIR ?= $(shell test -d $(XCODE_APP)/Contents/Developer/Platforms/$(PLATFORM_NAME).platform && echo $(XCODE_APP)/Contents/Developer/Platforms/$(PLATFORM_NAME).platform)
endif

ifeq ($(PLATFORM_DIR),)
ifneq ($(DEVELOPER_DIR),)
PLATFORM_DIR = $(DEVELOPER_PLATFORM_DIR)/$(PLATFORM_NAME).platform
endif
endif
export PLATFORM_DIR

## Set PLATFORM_DEVELOPER_SDK_DIR
PLATFORM_DEVELOPER_SDK_DIR = $(PLATFORM_DIR)/SDKs

## Set SDK_DIR
SDK_DIR ?= $(shell test -d $(PLATFORM_DEVELOPER_SDK_DIR)/$(SDK_NAME).sdk && echo  $(PLATFORM_DEVELOPER_SDK_DIR)/$(SDK_NAME).sdk)
ifneq ($(DEVELOPER_DIR),)
ifeq ($(SDK_DIR),)
SDK_DIR = $(DEVELOPER_SDK_DIR)/$(SDK_NAME).sdk
endif
endif
export SDK_DIR

## Set SDK_{C,LD,CPP}FLAGS
ifneq ($(SDK_DIR),)
SDK_CPPFLAGS = -isysroot $(SDK_DIR)
SDK_CFLAGS = -isysroot $(SDK_DIR)
SDK_LDFLAGS = -isysroot $(SDK_DIR)
endif

## Set CFLAGS
CFLAGS ?= -arch $(CURRENT_ARCH) $(SDK_CFLAGS) -I$(prefix)/include
export CFLAGS
## Set LDFLAGS
LDFLAGS ?= -arch $(CURRENT_ARCH) $(SDK_LDFLAGS)  -L$(prefix)/lib
export LDFLAGS
## Set CPPFLAGS
CPPFLAGS ?= $(SDK_CPPFLAGS) -I$(prefix)/include
export CPPFLAGS
