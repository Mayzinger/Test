src_dir="/path/to/source"  # исходная директория с файлами и подпапками
dest_dir="/path/to/destination"  # целевая директория

# Перемещаем все файлы, добавляем суффикс при совпадении имен
hdfs dfs -ls -R "$src_dir" | grep -v '^d' | awk '{print $8}' | while read file; do
    filename=$(basename "$file")
    dest_file="$dest_dir/$filename"

    # Проверяем, существует ли файл в целевой папке
    if hdfs dfs -test -e "$dest_file"; then
        # Добавляем суффикс времени или другой уникальный идентификатор
        suffix=$(date +%s)
        dest_file="$dest_dir/${filename%.*}_$suffix.${filename##*.}"
    fi
    
    hdfs dfs -mv "$file" "$dest_file"
done
