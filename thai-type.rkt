#lang racket
(require 2htdp/image 2htdp/universe "thai-lang.rkt")

(คือ-ร่าง now (target chars right wrong))

;; ordered in rows according to the ปัตตะโชติ layout
(คือ all-chars '(;; unshifted
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

(คือ (pick-target chars)
    (สาย (list-ref chars (random (ยาว chars)))))

(คือ/คู่ (key state pressed)
      [((now pressed chars right wrong) pressed) (now (pick-target chars) chars
                                                      (ขอนส pressed right) wrong)]
      [((now target chars right wrong) pressed)
       (if (< 1 (สาย-ยาว pressed))
           state ; assume it's a modifier
           (now (pick-target chars) chars
                right (ขอนส pressed wrong)))])

(คือ (draw state)
    (overlay/offset (above/align "middle"
                                 (text "Type this!" 48 "black")
                                 (text (now-target state) 72 "black")
                                 (beside (text (สาย-ผนวก (ยาว (now-right state))
                                                         " right")
                                               18 "blue")
                                         (text " | " 20 "black")
                                         (text (สาย-ผนวก (ยาว (now-wrong state))
                                                         " wrong")
                                               18 "red")))
                    20 20 (empty-scene 800 600)))

(module+ main
  (ยอม ([chars (สาธก/พับ ([chars '()]) ([r '(2)])
                 (ผนวก chars (string->list (list-ref all-chars r))))])
    (big-bang (now (pick-target chars) chars '() '())
              (on-key key)
              (to-draw draw))))
