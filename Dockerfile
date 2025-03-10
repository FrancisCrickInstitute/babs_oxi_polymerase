FROM julia:1.11.3-bookworm
WORKDIR /uv_polymerase
COPY . .
RUN tar -xzf /uv_polymerase/www/anim_file.tar.gz -C /uv_polymerase/www && rm -rf /uv_polymerase/www/anim_file.tar.gz
RUN julia -e 'using Pkg;Pkg.add(PackageSpec(path="/uv_polymerase"))'
EXPOSE 8080
CMD ["julia", "-e", "using oxi_polymerase; oxi_polymerase.start_server()"]
