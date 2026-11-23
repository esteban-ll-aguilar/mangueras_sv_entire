# Mangueras SV — Portafolio de Seguridad

Aplicación Flutter con backend Supabase y documentación de la auditoría técnica de la Unidad 1.

## Entregables

- [APE-01 — Fundamentos, criptografía y seguridad de la aplicación](APE-01/README.md)
- [APE-02 — Auditoría técnica y endurecimiento](APE-02/README.md)
- [Informes detallados](Documents/README.md)

## Estado técnico verificado

- `flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings`: correcto; únicamente avisos informativos.
- `flutter test --no-pub`: correcto.
- `flutter build web --release --no-pub`: correcto.
- Gitleaks: sin secretos detectados.
- Imagen web: construida con Nginx sin privilegios, puerto 8080 y actualización de paquetes Alpine.

## Ejecución local

```bash
flutter pub get
flutter run -d chrome
```

Para revisar el endurecimiento de la imagen, consultar [APE-02/Fase-04](APE-02/Fase-04/README.md).
