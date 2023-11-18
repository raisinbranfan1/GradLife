function T(s,a)
    if s == 0
        s′ = 0
        return s′
    end
    Digit_s = digits(s)
    F_s = Digit_s[1]
    E_s = Digit_s[2]
    K_s = Digit_s[3]
    P_s = Digit_s[4]
    if length(Digit_s) == 6
        T_s = 10*Digit_s[6] + Digit_s[5]
    else
        T_s = Digit_s[5]
    end
    if a == 1
        f = rand()
        e = rand()
        if f < 0.15
            F_s += 1
        elseif f > 0.85
            F_s += 3
        else
            F_s += 2
        end
        if e < 0.15
            E_s += 1
        elseif e > 0.85
            E_s += 3
        else
            E_s += 2
        end
        if F_s > 9
            F_s = 9
        end
        if E_s > 9
            E_s = 9
        end
        T_s += 1
        if T_s > 99
            T_s = 99
        end
    elseif a == 2
        f = rand()
        e = rand()
        if f < 0.15
            F_s += 3
        elseif f > 0.85
            F_s += 5
        else
            F_s += 4
        end
        if e < 0.15
            E_s += 3
        elseif e > 0.85
            E_s += 5
        else
            E_s += 4
        end
        if F_s > 9
            F_s = 9
        end
        if E_s > 9
            E_s = 9
        end
        T_s += 2
        if T_s > 99
            T_s = 99
        end
    elseif a == 3
        F_s = 9
        E_s = 9
        T_s += 8
        if T_s > 99
            T_s = 99
        end
    elseif a == 4
        f = rand()
        e = rand()
        k = rand()
        if f < 0.15
            F_s -= 4
        elseif f > 0.85
            F_s -= 6
        else
            F_s -= 5
        end
        if e < 0.15
            E_s -= 2
        elseif e > 0.85
            E_s -= 4
        else
            E_s -= 3
        end
        K_s += 1
        if F_s < 0
            F_s = 0
        end
        if E_s < 0
            E_s = 0
        end
        T_s += 2
        if T_s > 99
            T_s = 99
        end
    elseif a == 5
        f = rand()
        e = rand()
        if f < 0.15
            F_s -= 0
        else
            F_s -= 1
        end
        if e < 0.15
            E_s += 4
        elseif e > 0.85
            E_s += 6
        else
            E_s += 5
        end
        if F_s < 0
            F_s = 0
        end
        if E_s > 9
            E_s = 9
        end
        T_s += 1
        if T_s > 99
            T_s = 99
        end
    elseif a == 6
        f = rand()
        e = rand()
        if e < 0.15
            E_s -= 0
        else
            E_s -= 1
        end
        if f < 0.15
            F_s += 3
        elseif f > 0.85
            F_s += 5
        else
            F_s += 4
        end
        if E_s < 0
            E_s = 0
        end
        if F_s > 9
            F_s = 9
        end
        T_s += 1
        if T_s > 99
            T_s = 99
        end
    elseif a == 7
        f = rand()
        e = rand()
        k = rand()
        if K_s > 7
            if k < 0.15
                P_s += 2
            elseif f > 0.85
                P_s += 4
            else
                P_s += 3
            end
        elseif K_s > 4
            if k < 0.15
                P_s += 1
            elseif f > 0.85
                P_s += 3
            else
                P_s += 2
            end
        else
            if k < 0.15
                P_s += 0
            elseif f > 0.85
                P_s += 2
            else
                P_s += 1
            end
        end
        if e < 0.15
            E_s -= 3
        elseif f > 0.85
            E_s -= 5
        else
            E_s -= 4
        end
        if f < 0.15
            F_s -= 4
        elseif f > 0.85
            F_s -= 5
        else
            F_s -= 6
        end
        if E_s < 0
            E_s = 0
        end
        if F_s < 0
            F_s = 0
        end
        if P_s > 9
            P_s = 9
        end
        T_s += 3
        if T_s > 99
            T_s = 99
        end
    elseif a == 8
        T_s += 1
        if T_s == 100
            s′ = 0
            return s′
        end
    end
    s′ = T_s * 10000 + P_s * 1000 + K_s * 100 + E_s * 10 + F_s
    return s′
end