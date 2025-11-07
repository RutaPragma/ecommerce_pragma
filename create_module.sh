#!/bin/bash

# ============================================
# Script para crear módulos Flutter con arquitectura limpia
# Autor: Jhony Rentería
# Uso:
#   ./create_module.sh <nombre_modulo> [flags]
#
# Flags disponibles:
#   --no-presenter     Omitir la capa "presenter"
#   --with-files       Crear archivos base automáticamente
# ============================================

# Validar nombre del módulo
if [ -z "$1" ]; then
  echo "Por favor, proporciona el nombre del módulo. Ejemplo:"
  echo "./create_module.sh products --no-domain --with-files"
  exit 1
fi

MODULE_NAME=$1
SKIP_PRESENTER=false
SKIP_PRESENTATION=false

# Leer los flags
for arg in "$@"
do
  case $arg in
    --no-presenter) SKIP_PRESENTER=true ;;
    --no-presenter) SKIP_PRESENTATION=true ;;
  esac
done

echo "Creando módulo: $MODULE_NAME"
BASE_PATH="lib/features/$MODULE_NAME"

# ============================================
# PRESENTER
# ============================================
if [ "$SKIP_PRESENTER" = false ]; then
  mkdir -p $BASE_PATH/presenter

  if [ "$CREATE_FILES" = true ]; then
    touch $BASE_PATH/presenter/${MODULE_NAME}.dart
  fi
fi

# ============================================
# PRESENTATION
# ============================================
if [ "$SKIP_PRESENTATION" = false ]; then
  mkdir -p $BASE_PATH/presentation/helper
  mkdir -p $BASE_PATH/presentation/pages
  mkdir -p $BASE_PATH/presentation/state
  mkdir -p $BASE_PATH/presentation/widgets

  if [ "$CREATE_FILES" = true ]; then
    touch $BASE_PATH/presentation/pages/${MODULE_NAME}_page.dart
    touch $BASE_PATH/presentation/state/${MODULE_NAME}_bloc.dart
  fi
fi

echo "Módulo '$MODULE_NAME' generado correctamente en $BASE_PATH"
