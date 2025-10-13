const phoneNumber = '593993114884';

final Uri phoneNumberUri = Uri(scheme: 'tel', path: phoneNumber);
final Uri whatsappUri = Uri(
  scheme: 'https',
  host: 'wa.me',
  path: phoneNumber,
);
final Uri emailUri = Uri(
  scheme: 'mailto',
  path: 'info@mangueras.com',
);
final Uri locationUri = Uri.parse(
  'https://www.google.com/maps?q=-3.673361707360947,-79.70205296564183'
);
