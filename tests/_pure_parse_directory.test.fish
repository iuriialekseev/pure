source (dirname (status filename))/fixtures/constants.fish
source (dirname (status filename))/../functions/_pure_parse_directory.fish
@echo (_print_filename (status filename))


function setup
    _purge_configs
    _disable_colors
end; setup


@test "_pure_parse_directory: returns current directory (without shortening)" (
    set --universal pure_shorten_prompt_current_directory_length $NONE

    mkdir -p /tmp/current/directory/
    cd /tmp/current/directory/

    _pure_parse_directory
) = $PWD

@test '_pure_parse_directory: replaces $HOME by ~' (
    pushd $HOME

    _pure_parse_directory
    popd
) = '~'

@test '_pure_parse_directory: shortens directory in prompt' (
    string length (_pure_parse_directory 1)
) -lt (string length $PWD)

@test '_pure_parse_directory: shorten current directory parts to given length (no terminal width provided)' (
    set --universal pure_shorten_prompt_current_directory_length 2
    mkdir -p /tmp/current/directory/
    cd /tmp/current/directory/

    _pure_parse_directory

) = "/tm/cu/directory"


@test '_pure_parse_directory: shorten current directory parts to given length when terminal width can fit exactly the shortened path' (
    set --universal pure_shorten_prompt_current_directory_length 2
    set directory_path "/tmp/current/directory/"
    mkdir -p $directory_path && cd $directory_path
    set shorten_directory_path (prompt_pwd --dir-length=$pure_shorten_prompt_current_directory_length)
    set terminal_width (string length $shorten_directory_path)

    _pure_parse_directory $terminal_width

) = "/tm/cu/directory"

@test '_pure_parse_directory: shorten current directory parts to given length when terminal width can fit more than shortened path' (
    set --universal pure_shorten_prompt_current_directory_length 2
    set directory_path "/tmp/current/directory/"
    mkdir -p $directory_path && cd $directory_path
    set shorten_directory_path (prompt_pwd --dir-length=$pure_shorten_prompt_current_directory_length)
    set bigger 3
    set terminal_width (math (string length $shorten_directory_path) + $bigger)

    _pure_parse_directory $terminal_width

) = "/tm/cu/directory"



@test '_pure_parse_directory: shorten current directory parts to minimal length when terminal isn\'t big enough to fit shortened path' (
    set --universal pure_shorten_prompt_current_directory_length 2
    set directory_path "/tmp/current/directory/"
    mkdir -p $directory_path && cd $directory_path
    set shorten_directory_path (prompt_pwd --dir-length=$pure_shorten_prompt_current_directory_length)
    set smaller 3    
    set terminal_width (math (string length $shorten_directory_path) - $smaller)

    _pure_parse_directory $terminal_width

) = "/t/c/directory"
