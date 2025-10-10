$files = @(
    "lib\Taller_http\README.md",
    "lib\Taller_http\QUICK_START.md",
    "lib\Taller_http\REQUISITOS_CUMPLIDOS.md"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Remover emojis comunes
        $emojis = @('😄', '🚀', '✅', '❌', '📋', '🔧', '🛠️', '🎯', '📱', '🌐', '💻', '🔍', '⚙️', '📦', '🎨', '💾', '⏳', '✨', '🎉', '📝', '🔑', '📚', '🎓', '📄', '🎬', '💡', '🔔', '⚠️', '📊', '🔗', '🎮', '🎥', '🖥️', '📲', '💬', '🧪', '🔐', '🚫', '🗑️', '1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣', '7️⃣', '8️⃣', '9️⃣', '0️⃣', '🤝', '👨‍💻', '👩‍💻')
        foreach ($emoji in $emojis) {
            $content = $content.Replace($emoji, '')
        }
        
        # Reemplazar numeros emoji por numeros normales
        $content = $content.Replace('1️⃣', '1.')
        $content = $content.Replace('2️⃣', '2.')
        $content = $content.Replace('3️⃣', '3.')
        $content = $content.Replace('4️⃣', '4.')
        $content = $content.Replace('5️⃣', '5.')
        $content = $content.Replace('6️⃣', '6.')
        
        # Remover tildes
        $content = $content.Replace('á', 'a')
        $content = $content.Replace('é', 'e')
        $content = $content.Replace('í', 'i')
        $content = $content.Replace('ó', 'o')
        $content = $content.Replace('ú', 'u')
        $content = $content.Replace('ñ', 'n')
        $content = $content.Replace('Á', 'A')
        $content = $content.Replace('É', 'E')
        $content = $content.Replace('Í', 'I')
        $content = $content.Replace('Ó', 'O')
        $content = $content.Replace('Ú', 'U')
        $content = $content.Replace('Ñ', 'N')
        
        $content | Set-Content $file -NoNewline -Encoding UTF8
        Write-Host "Limpiado: $file"
    }
}

Write-Host "Proceso completado!"
