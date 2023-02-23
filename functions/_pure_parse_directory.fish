function _pure_parse_directory \
    --description "Replace '$HOME' with '~'" \
    --argument-names max_path_length

    set --local directory (prompt_pwd --dir-length=$pure_shorten_prompt_current_directory_length)

    if test -n "$max_path_length";
        if test (string length $directory) -gt $max_path_length;
            # If path exceeds maximum symbol limit, force fish path formating function to use 1 character
            set directory (prompt_pwd --dir-length=1)
        end
    end
    echo $directory
end
