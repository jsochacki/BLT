################################################################################
# Programmer:		Collin Bolles
# Creation Date: 	December 22 2020
################################################################################

#*******************************************************************************
# Preamble
#*******************************************************************************
# Baseline values, will be added onto later in the Makefile
CPPFLAGS		=
INCLUDE			=
CPPDEPFLAGS		=

# Output directories
MAKEROOT		:= ./
OBJ				= $(MAKEROOT)obj/
TMP				= $(MAKEROOT)tmp/

#*******************************************************************************
# Setup Project
#*******************************************************************************
DEBUG			= false
QUIET			= true

# Sources and include directories
SRCDIRS			= ./src
INCDIRS			= ./inc

#*******************************************************************************
# Object file creation generation
#*******************************************************************************
vpath %.cpp $(SRCDIRS)
vpath %.c 	$(SRCDIRS)

TARGET			= $(MAKEROOT)executible
MAKEFILE		= $(MAKEROOT)Makefile

INCLUDE			+= $(foreach DIR, $(INCDIRS), -I$(DIR)) \ 
				   $(foreach DIR, $(SYSINCDIRS), -isystem $(DIR))

#*******************************************************************************
# Copy pasta for system checking
#*******************************************************************************
# operating system
HOST_OS   := $(shell uname -s 2>/dev/null | tr "[:upper:]" "[:lower:]")
TARGET_OS ?= $(HOST_OS)
ifeq (,$(filter $(TARGET_OS),linux darwin qnx android))
    $(error ERROR - unsupported value $(TARGET_OS) for TARGET_OS!)
endif

# architecture
HOST_ARCH   := $(shell uname -m)
TARGET_ARCH ?= $(HOST_ARCH)
ifneq (,$(filter $(TARGET_ARCH),x86_64 aarch64 ppc64le armv7l))
    ifneq ($(TARGET_ARCH),$(HOST_ARCH))
        ifneq (,$(filter $(TARGET_ARCH),x86_64 aarch64 ppc64le))
            TARGET_SIZE := 64
        else ifneq (,$(filter $(TARGET_ARCH),armv7l))
            TARGET_SIZE := 32
        endif
    else
        TARGET_SIZE := $(shell getconf LONG_BIT)
    endif
else
    $(error ERROR - unsupported value $(TARGET_ARCH) for TARGET_ARCH!)
endif
ifneq ($(TARGET_ARCH),$(HOST_ARCH))
    ifeq (,$(filter $(HOST_ARCH)-$(TARGET_ARCH),aarch64-armv7l x86_64-armv7l \
			x86_64-aarch64 x86_64-ppc64le))
        $(error ERROR - cross compiling from $(HOST_ARCH) to \
			$(TARGET_ARCH) is not supported!)
    endif
endif

#*******************************************************************************
# Settings for portability
#*******************************************************************************
ifeq ($(TARGET_OS),cygwin)
   GNU			= /bin/
   CCBIN		= /usr/bin/
   BIN			= /usr/bin/
endif

ifeq ($(TARGET_OS),linux)
   GNU			= /bin/
   CCBIN		= /usr/bin/
   BIN			= /usr/bin/
   NVCCBIN		= $(CUDA_DIR)/bin/
endif

ifeq ($(TARGET_OS),osx)
   GNU			= /bin/
   CCBIN		= /usr/bin/
   BIN			= /usr/bin/
   NVCCBIN		= $(CUDA_DIR)/bin/
endif

#*******************************************************************************
# Setup Compiler and Binutils
#*******************************************************************************
HOST_COMPILER	= g++

ECHO            = @$(GNU)echo
RM              = $(GNU)rm -f
MKDEP           = @$(BIN)$(HOST_COMPILER) -MM -MG -MP
MKDIR           = @$(GNU)mkdir -p

#*******************************************************************************
# Setup Targets
#*******************************************************************************
all: $(TARGETS)
	chmod a+x $(TARGET)

#*******************************************************************************
# All Objects
#*******************************************************************************
FIND_CPP_FILES		= $(wildcard $(DIR)*.cpp)
CPP_FILES			:= $(foreach DIR, $(SRCDIRS), $(FIND_CPP_FILES))
CPP_FILE_OBJ		:= $(patsubst %.cpp, $(OBJ)%.o, $(notdir $(CPP_FILES)))
CPP_FILE_DEP		:= $(patsubst %.cpp, $(TMP)%.cpp.d, $(notdir $(CPP_FILES)))

DEPENDS				= $(CPP_FILE_DEP)
OBJECT				= $(CPP_FILE_OBJ)@s


$(OBJ)%.o: %.cpp $(MAKEFILE)
	$(ECHO) [$(notdir $<).d] from [$<]
	$(ECHO) -n $(OBJ) 	$(TMP)$(notdir $<).d
	$(MKDEP) $(CPPDEPFLAGS) $(INCLUDE) $< >	$(TMP)$(notdir $<).d
	$(ECHO) [$@] from [$<]
	$(ECHO)
	$(ECHO)

#*******************************************************************************
# Object Linking and Target Output
#*******************************************************************************
$(TARGET): $(OBJECTS)
	$(ECHO) [$@]
	$(ECHO)
	$(CCPP) $(CCPPFLAGS) $(OBJECTS) -o $@
	$(ECHO)

ifeq (, $(filter $(MAKECMDGOALS), clean debug))
	# Things to execute if we aren't cleaning
	include $(TMP)tmpdir.txt
	include $(OBJ)objdir.txt
	-include $(DEPENDS)
endif

#*******************************************************************************
# Makefile Generation
#*******************************************************************************
$(TMP)tmpdir.txt:
	$(ECHO) [$@]
	$(MKDIR) $(dir $(TMP))
	$(ECHO) "# This is the Temporary File Directory." 	$@

$(OBJ)objdir.txt:
	$(ECHO) [$@]
	$(MKDIR) $(dir $(OBJ))
	$(ECHO) "# This is the OBJ File Directory." 	$@

.PHONY: debug
debug: $(MAKEFILE)
	$(ECHO)
	$(ECHO) Recognized source files
	$(ECHO) $(FIND_CPP_FILES)
	$(ECHO) $(CPP_FILES)
	$(ECHO) $(CPP_FILE_OBJ)
	$(ECHO) $(CPP_FILE_DEP)
	$(ECHO)
	$(ECHO) Dependencies and objects
	$(ECHO) $(DEPENDS)
	$(ECHO) $(OBJECTS)
	$(ECHO)
	$(ECHO) Source Directories
	$(ECHO) $(SRCDIRS)
	$(ECHO) $(INCDIRS)
	$(ECHO) $(SYSINCDIRS)
	$(ECHO)
	$(ECHO) Compiler Information
	$(ECHO) $(CCPP)
	$(ECHO) $(HOST_COMPILER)
	$(ECHO) $(TARGET_OS)

# Cleans up all temporary files, including object files.
.PHONY: clean
clean:
	$(ECHO)
	$(ECHO) Removing backup and temporary files
	$(ECHO)
	$(RM) $(foreach DIR, $(SRCDIRS) $(MAKEROOT), $(wildcard $(DIR)*.bak))
	$(RM) $(foreach DIR, $(SRCDIRS) $(MAKEROOT), $(wildcard $(DIR)*.~*))
	$(RM) $(foreach DIR, $(SRCDIRS) $(MAKEROOT), $(wildcard $(DIR)*.tmp))
	$(RM) $(foreach DIR, $(SRCDIRS) $(MAKEROOT), $(wildcard $(DIR).*.swp))
	$(ECHO)
	$(ECHO) Removing object files
	$(ECHO)
	$(RM) $(notdir $(wildcard $(OBJ)*))
	$(ECHO)
	$(ECHO) Removing linker output files
	$(ECHO)
	$(RM) $(TARGET)
	$(ECHO)
	$(ECHO) Removing makefile generated directories
	$(ECHO)
	$(RM) -r $(TMP)
	$(RM) -r $(OBJ)
