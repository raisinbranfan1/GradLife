function R(s,a)
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
    R = 0
    final_r = F_s*E_s*K_s*P_s^2
    if a == 1
    elseif a == 2
        if T_s > 97
            R = -50
        end
    elseif a == 3
        if T_s > 91
            R = -50
        end
    elseif a == 4
        if T_s > 97
            R = -50
        end
        if E_s < 3 || F_s < 5
            R = -100
        end
    elseif a == 5
        if F_s < 1
            R = -100
        end
    elseif a == 6
        if E_s < 1
            R = -100
        end
    elseif a == 7
        if T_s > 96
            R = -50
        end
        if E_s < 4 || F_s < 6
            R = -100
        end
    elseif a == 8
        if T_s == 99
            R = final_r
        end
    end
    return R
end