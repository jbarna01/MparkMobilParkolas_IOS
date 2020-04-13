//
//  Konstans.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 24..
//  Copyright © 2020. BJ. All rights reserved.
//

struct Konst {
    struct enviroment {
        static let host: String = "mpark.moimo.hu";
        static let protokol: String = "http";
        static let registrationUrl = "/resources/phones/register";
        static let accountGetUrl = "/resources/phones/account";
        static let startParkingPostUrl = "/resources/parkings/startParking";
        static let accountPlatesGetUrl = "/resources/plates/getPlates";
        static let changeAktPlatesPostUrl = "/resources/plates/selectPlate";
    }
    struct identifier {
        static let onePlateCell: String = "onePlateCell";
    }
    struct szoveg {
        static let reg_tajekoztato: String = "SMS üzenetben küldtük Önnek a regisztrációs kódot. Kérjük írja be, és nyomjon a Belépés gombra!"
    }
    struct paceholder {
        static let regisztraciosKod: String = "Regisztrációs kód";
    }
    struct GombSzoveg {
        static let belepes = "Belépés";
    }
    struct title {
        static let nincsKapcsolat = "Nincs kapcsolat!"
    }
    
    struct info {
        static let msg_001: String = "Valóban törli a regisztrációját?";
        static let info_002: String = "Nincs megadva regisztrációs kód";
        static let info_003: String = "Nem helyes a regisztrációs kód!";
        static let msg_004: String = "Sikertelen művelet! Időtúllépés!";
        static let info_005: String = "Nincs megadva ZÓNA kód"
        static let info_006: String = "A ZÓNA kód 4 jegyűnek kell lennie!";
        static let msg_007: String = "A parkolás indítása nem sikerült!";
        static let msg_008: String = "Nem sikerült a rendszám váltás!";
        static let msg_009: String = "Nem lehet lekérdezni a rendszámokat!";
        static let info_010: String = "Nincskapcsolat";
        static let info_011: String = "Az alkalmazás hazsnálatához Internet kapcsolat szükséges!";
    }
    struct error {
        static let err_1001: String = "Mobil alkalmazás használata nem engedélyezett!";
        static let err_1002: String = "Nem sikerült lekérdezni a felhasználói adatokat!\n\rKérem próbálja újra!";
        static let msg_1003: String = "????????";
        
        static let err_2001: String = "Hibás regisztrációs kód!";
        static let err_2002: String = "Mobil alkalmazás regisztrációja sikertelen!";
        static let err_3001: String = "Nincs elég egyenlege!";
        static let err_3002: String = "Hibás ZÓNA kód!";
        static let err_3003: String = "Nem sikerült a parkolást elindítani!";
        static let msg_4001: String = "Nem sikerült leállítani a parkolást!\n\rKérem próbálja újra, vagy állítsa le telefonhívás segítségével!";
        static let msg_4002: String = "Ezt a parkolást már leállították!";
        static let err_5001: String = "Nem sikerült a rendszám váltás! Kérem próbálja újra!";
        static let err_5002: String = "A rendszámon parkolás fut.\n\rA rendszám váltás nem lehetséges!";
        static let err_9998: String = "Időtúllépés!";
        static let err_9999: String = "Sikertelen művelet!";
    }
    struct kapcsolatok {
        static let startToRegistration = "startToRegistration";
        static let startToParking = "startToParking";
        static let runToParking = "runToParking";
        static let rendszamValatas = "rendszamValatas";
    }
    struct tabbar {
        static let parkolok = 0;
        static let parkolasom = 1;
        static let profilom = 2;
    }
    
}
