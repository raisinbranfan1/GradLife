# GradLife
Optimization of Graduate Student Academic Performance

# Scripts
transition.jl - returns a sampled probablistic transition from a given state and action

reward.jl - returns a sampled reward from a given state and action

grad.jl - trains a model-free policy on chosen hyperparameters
Implemented options: Q-Learning, Sarsa, SarsaLambda, Random

generate.jl - generate a single run of the student week given a chosen policy

stats.jl - returns the average cumulative reward from running a chosen policy for a number of times

# Training files
grad.Q - stores the state-action values of the current model being trained

grad.policy - stores the current policy of the model being trained

grad.path - stores the state and actions taken for a simulation run through generate.jl

# Saved policies
grad.policy1e8QLearn - Q-Learning policy with 100 million iterations

grad.policy1e7Sarsa - Sarsa policy with 10 million iterations

grad.policy1e8Sarsa - Sarsa policy with 100 million iterations

grad.Q1e8QLearn - Q-Learning Q table with 100 million iterations

grad.Q1e7Sarsa - Sarsa Q table with 10 million iterations

grad.Q1e8Sarsa - Sarsa Q table with 100 million iterations

grad.Q1e8SarsaNoEnd - Sarsa Q table with 100 million iterations with no correction of action at time 99

grad.policyRandom - Random policy
