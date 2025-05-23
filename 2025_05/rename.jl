using Random

# Set a fixed seed for reproducibility
Random.seed!(20250523)

# Directory and output file
stimuli_dir = "images"
mapping_file = "stimulus_renaming.txt"

# Get original filenames
files = filter(f -> startswith(f, "stimulus_") && endswith(f, ".png"), readdir(stimuli_dir))

# Generate unique 10-character names
charset = ['a':'z'; '0':'9']
function random_id()
    join(rand(charset, 10))
end

function generate_unique_ids(n)
    ids = Set{String}()
    while length(ids) < n
        push!(ids, random_id())
    end
    return collect(ids)
end

new_names = generate_unique_ids(length(files))

# Write mapping and rename files using git
open(mapping_file, "w") do io
    for (old, new) in zip(files, new_names)
        old_path = joinpath(stimuli_dir, old)
        new_file = new * ".png"
        new_path = joinpath(stimuli_dir, new_file)
        run(`git mv $old_path $new_path`)
        println(io, "$old => $new_file")
    end
end

println("Renaming complete. Mapping saved to $mapping_file.")
