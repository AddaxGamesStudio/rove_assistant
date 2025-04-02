#!/bin/bash

build_and_copy() {
    local app_name=$1
    echo "📱 Building ${app_name}..."
    
    cd "rove_${app_name}"
    
    echo "🛠️ Building for web..."
    flutter build web --base-href "/rove_${app_name}_web/"
    
    cd ..
    
    echo "📂 Copying build files to web directory..."
    cp -R "rove_${app_name}/build/web/"* "../rove_${app_name}_web"
    
    echo "✅ ${app_name} build and copy completed successfully!"
    echo "-------------------------------------------"
}

build_and_copy "assistant"
build_and_copy "editor"
build_and_copy "simulator"
