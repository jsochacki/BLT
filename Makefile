################################################################################
# Programmer:		Collin Bolles
# Creation Date:	December 22 2020
################################################################################

#*******************************************************************************
# Preamble
#*******************************************************************************
# Change the recipe prefix to fix tab/space issues
.RECIPEPREFIX = |

# Specify the default target
.DEFAULT_GOAL	= main

# Baseline values which are added onto
CPPFLAGS		= -ggdb --std=c++14
INCLUDE			=

# Output Directories
MAKEFILE		= Makefile
BUILD_DIR		= build/
OBJ_DIR			= $(BUILD_DIR)obj/
TMP				= $(BUILD_DIR)tmp/

# Main Target
TARGET			= main

#*******************************************************************************
# Project Locations
#*******************************************************************************
SRC_DIRS		= $(MAKEROOT)src/
INC_DIRS		= $(MAKEROOT)inc/

FIND_CPP_FILES	= $(wildcard $(DIR)*.cpp)
CPP_FILES		:= $(foreach DIR, $(SRC_DIRS), $(FIND_CPP_FILES))

CPPFLAGS		+= -Iinc/
#*******************************************************************************
# Source Search Paths
#*******************************************************************************
# Set search paths
vpath %.cpp $(SRC_DIRS)
vpath %.c	$(SRC_DIRS)
vpath %.hpp $(INC_DIRS)

#*******************************************************************************
# Set Compiler and Commands
#*******************************************************************************
CCPP			= g++
ECHO			= @$(GNU)echo
RM				= $(GNU)rm -f
MKDIR			= @$(GNU)mkdir -p

#*******************************************************************************
# Setup Dependencies
#*******************************************************************************
DEPS			= $(INC_DIRS)
OBJS			+= $(patsubst %.cpp, $(OBJ_DIR)%.o, $(notdir $(CPP_FILES)))

# Handle opencv linking
CPPFLAGS		+= `pkg-config opencv4 --cflags --libs`

#*******************************************************************************
# Object file generations
#*******************************************************************************
$(OBJ_DIR)%.o: %.cpp
| $(MKDIR) $(BUILD_DIR)
| $(MKDIR) $(OBJ_DIR)
| $(CCPP) -c $< -o $@ $(CPPFLAGS)

#*******************************************************************************
# Main Taget
#*******************************************************************************
$(TARGET): $(OBJS)
| $(CCPP) $(OBJS) -o $(BUILD_DIR)$@ $(CPPFLAGS)

.PHONY: debug
debug: $(MAKEFILE)
| $(ECHO) Recognized Source Files
| $(ECHO) "CPP_FILES: " $(CPP_FILES)
| $(ECHO)
| $(ECHO) Source Directories
| $(ECHO) "SRC_DIRS: " $(SRC_DIRS)
| $(ECHO)
| $(ECHO) Generated Files
| $(ECHO) "OBJ_DIR: " $(OBJ_DIR)
| $(ECHO) "OBJS: " $(OBJS)

.PHONY: clean
clean:
| $(ECHO) Emptying Build Dir
| $(RM)	$(BUILD_DIR)$(TARGET)
| $(RM) $(OBJ_DIR)*
