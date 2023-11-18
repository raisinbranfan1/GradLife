using Graphs
using Printf
using CSV
using DataFrames
using SpecialFunctions
using Random
using LinearAlgebra
using TickTock
include("transition.jl")
include("reward.jl")

function TR(s,a)
    s′ = T(s,a)
    r = R(s,a)
    return s′, r
end

mutable struct EpsilonGreedyExploration
    ϵ
end

struct MDP
    γ # discount factor
    S # state space
    A # action space
    TR # sample transition and reward
end

mutable struct QLearning
    S
    A
    γ
    Q
    α
end

lookahead(model::QLearning, s, a) = model.Q[s,a]

function update!(model::QLearning, s, a, r, s′)
    γ, Q, α = model.γ, model.Q, model.α
    Q[s,a] += α*(r + γ*maximum(Q[s′, :]) - Q[s,a])
    return model
end

function (π::EpsilonGreedyExploration)(model, s)
    A, ϵ = model.A, π.ϵ
    if rand() < ϵ
        return rand(A)
    end
    Q(s,a) = lookahead(model, s, a)
    return argmax(a->Q(s,a), A)
end

function simulate(P::MDP, model, π, h, s)
    for i in 1:h
        a = π(model, s)
        s′, r = P.TR(s,a)
        update!(model, s, a, r, s′)
        s = s′
    end
end

# tick()
# γ = 1
# S = collect(0:1:999999)
# A = collect(1:1:7)
# P = MDP(γ, S, A, TR)
# k = 20000
# ϵ = 0.1
# s = 10055
# α = 0.2
# Q = zeros(length(P.S), length(P.A))
# π = EpsilonGreedyExploration(ϵ)
# model = QLearning(P.S, P.A, P.γ, Q, α)
# simulate(P, model, π, k, s)
# policy = rand(1:7,1000000,1)
# for i in 0:999999
#     policy[i] = argmax(a->Q[i,a], A)
# end
# io = open("grad.policy", "w") do io
#     for x in policy
#         println(io, x)
#     end
# end
# tock()

policy = rand(1:7,1000000,1)
s = 10055
Reward = 0
while s != 0
    a = policy[s + 1]
    if s >= 990000
        a = 8
    end
    s_new,r = TR(s, a)
    global Reward += r
    print("State: ", s, " Action taken: ", a, " Reward total: ", Reward, "\n")
    global s = s_new
end

# 1 - Short nap
# 2 - Medium nap
# 3 - Long nap
# 4 - Study
# 5 - Eat 
# 6 - Break 
# 7 - Do PSet
# 8 - Do nothing (redeems end reward at time 99 and transitions to state 0)