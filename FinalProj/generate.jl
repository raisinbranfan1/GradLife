using Printf
using CSV
using DataFrames
using SpecialFunctions
using Random
using LinearAlgebra
include("transition.jl")
include("reward.jl")

function decode_state(s)
    Digit_s = digits(s)
    if length(Digit_s) < 2
        T_s = 0
        F_s = 0
        E_s = 0
        K_s = 0
        P_s = 0
    else
        F_s = Digit_s[1]
        E_s = Digit_s[2]
        K_s = Digit_s[3]
        P_s = Digit_s[4]
        if length(Digit_s) == 6
            T_s = 10*Digit_s[6] + Digit_s[5]
        else
            T_s = Digit_s[5]
        end
    end
    return T_s, P_s, K_s, E_s, F_s
end



function TR(s,a)
    s′ = T(s,a)
    r = R(s,a)
    return s′, r
end

policy_file = "./SavedRuns/grad.policy1e8Sarsa"

policy = CSV.read(policy_file, DataFrame, header = 0)
E_rand = rand(1:9)
F_rand = rand(1:9)
s = 10000 + E_rand*10 + F_rand
a = policy[s+1, 1]
action_bank = ["Short nap", "Medium nap", "Long nap", "Study", "Eat", "Break", "Do PSet", "Do nothing"]
path = DataFrame(Time = [], PSet = [], Knowledge = [], Energy = [], Focus = [], Action = [], Reward = [], Transition = [])
while s != 0
    s′, r = TR(s,a)
    T_s, P_s, K_s, E_s, F_s = decode_state(s)
    T_s′, P_s′, K_s′, E_s′, F_s′ = decode_state(s′)
    diff = [T_s′ - T_s, P_s′ - P_s, K_s′ - K_s, E_s′ - E_s, F_s′ - F_s]
    diff_vars = ["Time", "PSet", "Knowledge", "Energy", "Focus"]
    diff_msg = []
    for (i,d) in enumerate(diff)
        if d == 0
            push!(diff_msg, "")
        elseif d > 0
            push!(diff_msg, join(["+", string(d), " ", diff_vars[i], "  "]))
        elseif d < 0
            push!(diff_msg, join([string(d), " ", diff_vars[i], "  "]))
        end
    end
    if s′ != 0
        trans_msg = join([action_bank[a], " => ", join(diff_msg)])
    else
        trans_msg = "Week completed"
    end
    push!(path,[T_s, P_s, K_s, E_s, F_s, a, r, trans_msg])
    global s = s′
    global a = policy[s+1, 1]
end
print(path)
CSV.write("grad.path", path, delim=' ')