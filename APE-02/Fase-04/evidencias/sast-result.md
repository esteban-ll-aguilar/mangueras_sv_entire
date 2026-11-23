# Evidencia SAST

## Comandos

```bash
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings
flutter test --no-pub
flutter build web --release --no-pub
```

## Resultado

Los tres comandos finalizaron con código 0. El analizador reportó 189 avisos informativos/lints, sin errores bloqueantes. La compilación web generó `build/web` y las pruebas automatizadas finalizaron correctamente.

## Hallazgos corregidos

| Área | Hallazgo | Acción |
|---|---|---|
| Auth | Conflictos Git sin resolver en providers y login | Se conservaron las implementaciones compatibles y se eliminaron marcadores `<<<<<<<`, `=======`, `>>>>>>>`. |
| Inventory | Conflictos en repositorios de productos y almacenamiento | Se integró una única implementación válida y se comprobó con análisis/build. |
| Shop | Conflictos en filtros y grilla | Se resolvió la vista final y se comprobó con análisis/build. |
| Secretos | Riesgo de tokens de laboratorio en el repositorio | Se reemplazaron por `<REDACTED_LAB_TOKEN>` y Gitleaks terminó sin hallazgos. |
