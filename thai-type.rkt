#lang racket
(require 2htdp/image 2htdp/universe "thai-lang.rkt")

;; (define-struct now (target characters right wrong))
;; (kheuu-raang phuu mi' (joot-mai/ aak`-saawn/ thuuk` phit`))
(คือ-ร่าง ภูมิ (จุดหมาย อักษร ถูก ผิด) #:transparent)

;; (define all-characters ...)
;; (kheuu aak`-saawn/ - thuaa\ ...)
;; ordered in rows according to the ปัตตะโชติ layout
(คือ อักษร-ทั่ว '(;; unshifted
              "_=๒๓๔๕ู๗๘๙๐๑๖"
              "็ตยอร่ดมวแใฌๅ"
              "้ทงกัีานเไข"
              "บปลหิคสะจพ"
              ;; shifted
              "฿+\"/,?ุ_.()-%"
              "๊ฤๆญษึฝซถฒฯฦํ"
              "๋ธำณ์ืผชโฆฑ"
              "ฎฏฐภฺศฮฟฉฬ"
              ))

;; phit` - suung/ soot`
(คือ ผิด-สูงสุด 10)

;; kheet` - phit`
(คือ (ขีด-ผิด ผิด)
    (let* ([total-width 600]
           [second-width (if (zero? ผิด) 0
                             (* (/ ผิด ผิด-สูงสุด) total-width))])
      (overlay/xy (rectangle second-width 25 "solid" "red") 0 0
                  (rectangle total-width 25 "outline" "red"))))

;; (define (choose-target characters) ...)
;; (kheuu (leuuak\-joot-mai/ aak`-saawn/) ...)
(คือ (เลือก-จุดหมาย อักษร)
    (สาย (ราย-หา อักษร (ดะ (ยาว อักษร)))))

;; kheuu/khu`
(คือ/คู่ (key state pressed)
      [(_ "escape") (init)]
      [((ภูมิ pressed อักษร ถูก ผิด) pressed) (ภูมิ (เลือก-จุดหมาย อักษร) อักษร
                                                   (ขอนส pressed ถูก) ผิด)]
      [((ภูมิ จุดหมาย อักษร ถูก ผิด) pressed)
       (if (< 1 (สาย-ยาว pressed))
           state ; assume it's a modifier
           (ภูมิ (เลือก-จุดหมาย อักษร) อักษร
               ถูก (ขอนส จุดหมาย ผิด)))])

;; (kheuu (kheet` phu mi') ...)
(คือ (ขีด ภูมิ)
    (overlay/offset (above/align "middle"
                                 (text "Type this!" 48 "black")
                                 (text (ภูมิ-จุดหมาย ภูมิ) 72 "black")
                                 (ขีด-ผิด (ยาว (ภูมิ-ผิด ภูมิ)))
                                 (text (เบอร์-สาย (ยาว (ภูมิ-ถูก ภูมิ)))
                                       18 "blue"))
                    20 20 (empty-scene 800 600)))

(คือ (init)
  (ยอม ([อักษร (สาธก/พับ ([อักษร '()]) ([แถว '(1 2 3)])
                       (ผนวก อักษร (สาย->ราย (ราย-หา อักษร-ทั่ว แถว))))])
       (ภูมิ (เลือก-จุดหมาย อักษร) อักษร '() '())))

(คือ (หยุด? ภูมิ)
    (= ผิด-สูงสุด (ยาว (ภูมิ-ผิด ภูมิ))))

(module+ main
  (big-bang (init)
            (on-key key)
            (to-draw ขีด)
            (stop-when หยุด?)))
