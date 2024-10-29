src_dir="/path/to/source"  # исходная директория с файлами и подпапками
dest_dir="/path/to/destination"  # целевая директория

# Перебираем все файлы и сразу пытаемся переместить их в целевую папку
hdfs dfs -ls -R "$src_dir" | grep -v '^d' | awk '{print $8}' | while read -r file; do
    filename=$(basename "$file")
    dest_file="$dest_dir/$filename"

    # Сначала пробуем переместить файл
    if ! hdfs dfs -mv "$file" "$dest_file"; then
        # Если возникает ошибка (например, файл с таким именем уже существует), добавляем суффикс и пробуем снова
        suffix=$(date +%s%N)  # Уникальный суффикс с наносекундами
        dest_file="$dest_dir/${filename%.*}_$suffix.${filename##*.}"
        hdfs dfs -mv "$file" "$dest_file"
    fi
done
