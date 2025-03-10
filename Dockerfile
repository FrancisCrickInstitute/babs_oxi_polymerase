FROM julia:1.11.3-bookworm
WORKDIR /uv_polymerase
COPY . .
RUN julia -e 'using Pkg;Pkg.add(PackageSpec(path="/uv_polymerase"))'
EXPOSE 8080
CMD ["julia", "-e", "using oxi_polymerase; oxi_polymerase.start_server()"]
