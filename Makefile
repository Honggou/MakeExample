CC := gcc
CXX := g++

SRC_DIR := src 
OBJ_DIR := obj
DEPEND_DIR = depend
INC_DIR := include
INCLUDES := -I./$(INC_DIR) 

CFLAGS = 
CXXFLAGS = 
CPPFLAGS = $(INCLUDES) 
LFLAGS=

LDIRS = 
TARGET = test.exe


#SOURCES := $(notdir $(wildcard $(SRC_DIR)/*.c $(SRC_DIR)/*.cpp))
SOURCES_PATH := $(foreach dir, $(SRC_DIR), $(wildcard $(dir)/*.c $(dir)/*.cpp))  
SOURCES := $(notdir $(SOURCES_PATH))
#C_SRCS := $(filter %.c, $(SOURCES))
#CPP_SRCS := $(filter %.cpp, $(SOURCES))
OBJ := $(addprefix $(OBJ_DIR)/, $(basename $(SOURCES)))  
OBJ := $(addsuffix .o, $(OBJ))

DEPENDS := $(addprefix $(DEPEND_DIR)/, $(basename $(SOURCES)))
DEPENDS := $(addsuffix .d, $(DEPENDS))

#vpath %.h $(INC_DIR)
#vpath %.hpp $(INC_DIR)
vpath %.c $(SRC_DIR)
vpath %.cpp $(SRC_DIR)

#include $(SOURCES_PATH:.c=.d)
include $(DEPENDS)


$(OBJ_DIR)/%.o: %.c
	@[ -d $(OBJ_DIR) ] || mkdir $(OBJ_DIR)
	$(CXX) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

$(OBJ_DIR)/%.o: %.cpp
	@[ -d $(OBJ_DIR) ] || mkdir $(OBJ_DIR)
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) $< -o $@

$(TARGET): $(OBJ) 
	$(CXX) -o $@ $(LDIRS) $(LFLAGS) $^

$(DEPEND_DIR)/%.d: %.c
	@[ -d $(DEPEND_DIR) ] || mkdir $(DEPEND_DIR)
	set -e; rm -f $@; \
	$(CXX) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	cp $@ $@.$$$$; \
	sed 's/./$(OBJ_DIR)\/&/' < $@.$$$$ > $@; \
	rm -rf $@.$$$$

all: $(TARGET)


.PHONY: all clean 
clean:
	-rm -rf $(OBJ_DIR) 
	-rm -rf $(DEPEND_DIR)
	-rm -rf *.exe
	
