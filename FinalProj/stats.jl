using Printf
using CSV
using DataFrames
using SpecialFunctions
using Random
using LinearAlgebra
using Statistics
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
policy_random = "./SavedRuns/grad.policyRandom"

policy_main = CSV.read(policy_file, DataFrame, header = 0)
policy_random = CSV.read(policy_random, DataFrame, header = 0)

nruns = 1000

reward_arr = zeros(nruns)
for i in 1:nruns
    reward_tot = 0
    E_rand = rand(1:9)
    F_rand = rand(1:9)
    global s = 10000 + E_rand*10 + F_rand
    global a = policy_main[s+1, 1]
    while s != 0
        s′, r = TR(s,a)
        reward_tot += r
        global s = s′
        global a = policy_main[s+1, 1]
    end
    reward_arr[i] = reward_tot
end

println("Average reward from trained policy:", mean(reward_arr))

reward_arr = zeros(nruns)
for i in 1:nruns
    reward_tot = 0
    E_rand = rand(1:9)
    F_rand = rand(1:9)
    global s = 10000 + E_rand*10 + F_rand
    global a = policy_random[s+1, 1]
    while s != 0
        s′, r = TR(s,a)
        reward_tot += r
        global s = s′
        global a = policy_random[s+1, 1]
    end
    reward_arr[i] = reward_tot
end

println("Average reward from random policy:", mean(reward_arr))