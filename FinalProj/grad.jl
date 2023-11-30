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

mutable struct Cust
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

mutable struct Sarsa
    S
    A
    γ
    Q
    α
    ℓ
end

mutable struct SarsaLambda
    S
    A
    γ
    Q
    N
    α
    λ
    ℓ
end

lookahead(model::QLearning, s, a) = model.Q[s+1,a]
lookahead(model::Sarsa, s, a) = model.Q[s+1,a]
lookahead(model::SarsaLambda, s, a) = model.Q[s+1,a]

function update!(model::QLearning, s, a, r, s′)
    γ, Q, α = model.γ, model.Q, model.α
    Q[s + 1,a] += α*(r + γ*maximum(Q[s′ + 1, :]) - Q[s + 1,a])
    return model
end

function update!(model::Sarsa, s, a, r, s′)
    if model.ℓ != nothing
        γ, Q, α, ℓ = model.γ, model.Q, model.α, model.ℓ
        model.Q[ℓ.s + 1, ℓ.a] += α*(ℓ.r + γ*Q[s+1,a] - Q[ℓ.s+1, ℓ.a])
    end
    model.ℓ = (s=s, a=a, r=r)
    return model
end

function update!(model::SarsaLambda, s, a, r, s′)
    if model.ℓ != nothing
        γ, λ, Q, α, ℓ = model.γ, model.λ, model.Q, model.α, model.ℓ
        model.N[ℓ.s + 1, ℓ.a] += 1
        δ = ℓ.r + γ*Q[s+1, a] - Q[ℓ.s + 1, ℓ.a]
        for s in model.S
            for a in model.A
                model.Q[s+1,a] += α*δ*model.N[s+1,a]
                model.N[s+1,a] *= γ*λ
            end
        end
    else
        model.N[:,:] .= 0.0
    end
    model.ℓ = (s=s, a=a, r=r)
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
        #print("state: ",s, ", action: ", a, "\n")
        s′, r = P.TR(s,a)
        N[s + 1, a] += 1
        update!(model, s, a, r, s′)
        s = s′
    end
end

tick()
γ = 1
S = collect(0:1:999999)
A = collect(1:1:8)
P = MDP(γ, S, A, TR)
k = 100
ϵ = 0.5
α = 0.2
Q = zeros(length(P.S), length(P.A))
N = zeros(length(P.S), length(P.A))
λ = 0.5
ℓ = nothing
model = "Sarsa"
if model == "QLearning"
    model = QLearning(P.S, P.A, P.γ, Q, α)
elseif model == "Sarsa"
    model = Sarsa(P.S, P.A, P.γ, Q, α, ℓ)
elseif model == "SarsaLambda"
    model = SarsaLambda(P.S, P.A, P.γ, Q, N, α, λ, ℓ)
end

if model != "Random"
    rollouts = 100000000
    for r in 1:rollouts
        E_rand = rand(1:9)
        F_rand = rand(1:9)
        s = 10000 + E_rand*10 + F_rand
        π = EpsilonGreedyExploration(ϵ)
        simulate(P, model, π, k, s)
        println("Rollout # ", r)
    end
end
policy = rand(1:8,1000000,1)
action_value = zeros(1000000)
if model != "Random"
    for i in 1:1000000
        policy[i] = argmax(a->Q[i,a], A)
        action_value[i] = Q[i,policy[i]]
    end
else
    for i in 1:1000000
        action_value[i] = Q[i,policy[i]]
        policy[990000:end] .= 8
    end
end

# DEBUG
# m = maximum(action_value)
# println(m)
# function myCondition(y)
#     return m == y
# end
# f = findfirst(myCondition, action_value)
# println(f)
# println(argmax(a->Q[f,a], A))
println("Unique Q: ",length(unique(action_value)))

io = open("grad.policy", "w") do io
    for x in policy
        println(io, x)
    end
end
io = open("grad.Q", "w") do io
    for x in action_value
        println(io, x)
    end
end
tock()


# 1 - Short nap
# 2 - Medium nap
# 3 - Long nap
# 4 - Study
# 5 - Eat 
# 6 - Break 
# 7 - Do PSet
# 8 - Do nothing (redeems end reward at time 99 and transitions to time 0)


# Short nap: + 1 energy, + 2 focus, + 1 hr
# Medium nap: + 2 energy, + 3 focus, + 2 hrs
# Long nap (basically full sleep) – full energy, full focus, + 8 hrs
# Studying: + 1 knowledge, - 4 energy, - 5 focus, + 2 hrs
# Eating: +3 energy, - 1 focus, + 1 hrs
# Mental/social break: + 4 focus, - 1 energy, + 1 hrs
# Do Pset: + Pset dependent on knowledge, - 5 energy, - 8 focus, + 3 hrs
