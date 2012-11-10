(require fluxus-018/fluxus-midi)
(require racket/vector)

(midiin-open 1)
(define camera-obj (build-sphere 1 1))

(lock-camera camera-obj)

(define camera-coords (list->vector '(64 64 64)))
(define camera-rotation (list->vector '(0 0 0)))

(define (camera)
  (let ([cc-12 (midi-cc 0 12)]
        [cc-11 (midi-cc 0 11)]
        [cc-14 (midi-cc 0 14)]
        [cc-24 (midi-cc 0 24)]
        [cc-26 (midi-cc 0 26)]
        [cc-29 (midi-cc 0 29)]
        [cc-36 (midi-cc 0 36)]
        [next-note (midi-note)])
    (with-primitive camera-obj
                    (translate
                     (vector
                      (/ (- (vector-ref camera-coords 0) cc-12) 5)
                      (/ (- (vector-ref camera-coords 1) cc-11) 5)
                      (/ (- cc-14 (vector-ref camera-coords 2)) 5)))

                    (cond [(and (>= cc-26 60) (<= cc-26 70)) (set! cc-26 64)])
                    (cond [(and (>= cc-29 60) (<= cc-29 70)) (set! cc-29 64)])
                    (cond [(and (>= cc-36 60) (<= cc-36 70)) (set! cc-36 64)])

                    (let ([frame-rotation
                     (vector (/ (- cc-26 64) 10)
                             (/ (- cc-29 64) 10)
                             (/ (- cc-36 64) 10))])
                      
                      (vector-map! + camera-rotation frame-rotation)

                      (cond [(and (vector? next-note)
                                  (eq? (vector-ref next-note 0) 'note-on)
                                  (= (vector-ref next-note 2) 44))
                             (set! camera-obj (build-sphere 1 1))
                             (lock-camera camera-obj)])
                             ;(vector-map! - frame-rotation camera-rotation)
                             ;(set! camera-rotation (vector 0 0 0))])
                      (rotate frame-rotation)))
                      
    (blur (+ 0.1 (/ cc-24 128.0)))


    (vector-set! camera-coords 0 cc-12)
    (vector-set! camera-coords 1 cc-11)
    (vector-set! camera-coords 2 cc-14)))

(persp)


(spawn-task camera 'camera)
