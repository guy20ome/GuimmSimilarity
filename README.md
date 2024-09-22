# NivatSimilarity
Fast string similarity calculation with TSQL standard string functions and trigrams.

Why trigrams, see the PostgreSQL doc : A trigram is a group of three consecutive characters taken from a string. We can measure the similarity of two strings by counting the number of trigrams they share. This simple idea turns out to be very effective for measuring the similarity of words in many natural languages.

This function is 10 times faster than LevenshteinEditDistance
