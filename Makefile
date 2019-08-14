BIN = build

OBJS = build/object

SOURCEDIR = \
pal/ \
optiga \

OUTPUT_LIB_DIR = \
build/

CC = /usr/bin/gcc

LIBS = -lrt

DEFINES = \
-DPAL_OS_HAS_EVENT_INIT

INCLUDE = \
-I./optiga/include/optiga/ifx_i2c/ \
-I./optiga/include/optiga/ \
-I./optiga/include/optiga/pal/ \
-I./optiga/include/optiga/comms/ \
-I./optiga/include/optiga/cmd/ \
-I./optiga/include/optiga/common/ \
-I./optiga/include/optiga/dtls/ \
-I./pal/libusb/include/ \
-I./pal/linux/

FLAGS = $(INCLUDE) $(LIBS) $(DEFINES)

$(OBJS)/%.o: pal/linux/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS) -c $< -o $@

$(OBJS)/%.o: pal/linux/target/rpi3/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS) -c $< -o $@

$(OBJS)/%.o: optiga/cmd/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS) -c $< -o $@

$(OBJS)/%.o: optiga/common/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS)  -c $< -o $@

$(OBJS)/%.o: optiga/comms/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS)  -c $< -o $@

$(OBJS)/%.o: optiga/comms/ifx_i2c/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS)  -c $< -o $@

$(OBJS)/%.o: optiga/crypt/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS)  -c $< -o $@

$(OBJS)/%.o: optiga/dtls/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS)  -c $< -o $@

$(OBJS)/%.o: optiga/util/%.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS)  -c $< -o $@

$(OBJS)/%.o: %.c
	@mkdir -p $(OBJS)
	$(CC) $(FLAGS) $(CPPFLAGS)  -c $< -o $@

TEST_CPP :=  $(shell find $(SOURCEDIR) -name '*.c') \
main.c
TEST_OBJ :=  $(addprefix $(OBJS)/,$(notdir $(TEST_CPP:.c=.o)))

$(BIN)/testRunner: lib
	@mkdir -p $(BIN)
	$(CC) $(FLAGS) -L$(OUTPUT_LIB_DIR)  -loptiga_x_rpi3 $(LIBS)  -o $@


.PHONY: all lib debug clean

all: $(BIN)/testRunner

lib: $(TEST_OBJ)
	ar rcs $(BIN)/liboptiga_x_rpi3.a $^

debug:
	@echo  $(TEST_CPP) "\n\n" $(TEST_OBJ)

clean:
	rm -rf build/