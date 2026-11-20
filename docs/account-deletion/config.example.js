// Hesap silme sayfasının ayarı. config.js olarak kopyala; config.js GitHub Pages'te yayımlanmak üzere commit'lenir (D51).
// Yalnız istemcide zaten bulunan herkese açık değerler: Supabase URL ve publishable/anon key.
// service_role / secret key ASLA buraya yazılmaz.
// Boş bırakılan alanlar: o yol gizlenir (ör. supabaseUrl yoksa yalnız uygulama içi ve e-posta yolu görünür).
window.NEUROPLAN_CONFIG = {
  supabaseUrl: '',   // https://PROJE-REF.supabase.co
  supabaseKey: '',   // publishable / anon key
  contactEmail: '',  // silme isteklerinin geleceği adres
};
