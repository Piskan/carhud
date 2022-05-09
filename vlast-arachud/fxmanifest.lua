-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'ByPislik'
description 'vlast carhud'
version '1.0.0'





ui_page 'html/ana.html'


files {
    'html/ana.html',
    'html/ana.css',
    'html/ana.js',
	'html/Gilroy-ExtraBold.otf',
	'html/WorkSans-SemiBold.ttf',
	


}



client_scripts {
    'ayarlar.lua',
    'client/ana.lua'
}
server_script {
     'ayarlar.lua',
    'server/ana.lua'

}