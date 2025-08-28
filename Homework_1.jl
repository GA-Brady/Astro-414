using CSV, DataFrames, Plots

function main()
    data_dir = "data/"
    figure_dir = "figures/"
    color_data_path = data_dir * "A414-F25_color-T.dat"

    # Read with auto-detected whitespace separator
    color_data = CSV.read(color_data_path, DataFrame; ignorerepeated=true, delim=' ')
    println(color_data)

    T = color_data[!, 2]   # Effective temperature
    BV = color_data[!, 1]  # B–V color index

    # Define round tick values for temperature
    tick_vals = [30000, 20000, 10000, 5000, 3000]
    tick_labels = string.(tick_vals)

    y_tick_vals = [-0.5, 0.0, 0.5, 1.0, 1.5, 2.0]
    y_tick_labels = string.(y_tick_vals)

    # HR diagram: log x-axis, reversed, with custom ticks
    HR_diagram = plot(
        T, BV;
        xscale = :log10,
        xticks = (tick_vals, tick_labels),
        xflip = true,
        xlabel = "Temperature (K)",
        ylabel = "B–V Color",
        ylims = (-0.5, 2.0),
        yticks = (y_tick_vals, y_tick_labels),
        yflip = true,
        title = "Hertzsprung–Russell Diagram",
        color = :black,
        legend = false,
        markersize = 4
    )
    savefig(HR_diagram, figure_dir * "HR_diagram.png")

    dBV = zeros(Float64, length(T), 1)
    for i in 2:length(T)
        dBV[i] = (BV[i] - BV[i-1]) / (T[i] - T[i-1])
    end

    dBV_plot = plot(
        T[2:end-1], dBV[2:end-1].*1000;
        xscale = :log10,
        xticks = (tick_vals, tick_labels),
        xflip = true,
        xlabel = "Temperature (K)",
        ylabel = "d(B–V)/dt ⋅ 1000",
        yflip = true,
        title = "Backwards Difference of B-V",
        color = :black,
        legend = false,
        markersize = 4
    )

    savefig(dBV_plot, figure_dir * "dBV_diagram.png")    
end

if abspath(PROGRAM_FILE) == @__FILE__
    results = main()
end