#lang racket

;; Dominio:   Numero entero de reinas y el numero de respuestas que se desean
;; Codominio: Matriz con respuestas correctas que se pueden dar de las respuestas solicitadas

(define backtrackingNReinas
  (lambda(n cont)
    (cond ((or(>= 3 n) (< cont 1)) '())
          (else (reinasAux '(0) n n cont)))))


;; Dominio:   Lista que guardanda las respuestas convirtiendose en matriz, numero de reinas, chequeador de si se llego al limite de las casillas permitidas donde se puede colocar una reina y contador del numero soluciones que desea retornar
;; Codominio: Matriz con respuestas correctas que se pueden dar de las respuestas solicitadas

(define reinasAux
  (lambda (lista n limite cont)
    (cond ((equal? cont 0) '())
          ((equal? (car lista) limite)
           (cond((equal? n limite) '())
                 (else (reinasAux (cons (+ 1 (cadr lista)) (cddr lista)) (+ n 1) limite cont))))
          ((valido? lista)
           (cond ((equal? n 1) (append (list lista) (reinasAux (cons (+ 1 (car lista)) (cdr lista)) n limite (- cont 1))))
                 (else (reinasAux (cons 0 lista) (- n 1) limite cont))))
          (else (reinasAux (cons (+ 1 (car lista)) (cdr lista)) n limite cont)))))

;; Dominio:   Una lista
;; Codominio: Un booleano que dicta si el ultimo elemento insertado es valido y no amenaza a ninguna reina

(define valido? 
  (lambda (lista)
    (cond ((or (ormap (lambda (x) (= x (car lista))) (cdr lista)) (diagonal? lista (- (longitud lista) 1) 0)) #f)
          (else #t))))

;; Dominio:   Una lista para verificarla, el tamano de la lista a verificar y el paso por el que se va analizando
;; Codominio: Un booleano que dice si el ultimo elemento no amenaza ninguna reina

(define diagonal?
  (lambda (lista n i)
    (cond ((equal? (longitud lista) 1) #f)
          ((equal? (abs(- (car (ultimo lista)) (car lista))) (abs(- i n))) #t)
          (else( diagonal? (drop-right lista 1) n (+ i 1))))))

;; Dominio:   Una lista
;; Codominio: Un entero que indica la longitud de la lista

(define longitud
  (lambda (l)
    (cond ((null? l) 0)
          (else (+ 1 (longitud (cdr l)))))))

;; Dominio:   Una lista
;; Codominio: Una lista con el ultimo elemento de la lista original

(define ultimo
  (lambda (l)
    (cond ((null? (cdr l)) l)
          (else (ultimo (cdr l))))))

;; Dominio:   Una funcion
;; Codominio: Un numero 0

(define nada
  (lambda(f)
    0))
