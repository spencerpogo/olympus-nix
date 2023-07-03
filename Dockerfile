FROM nixos/nix

RUN nix-channel --update

RUN mkdir /app
WORKDIR /app
COPY . .

RUN nix --extra-experimental-features 'flakes nix-command' build '.#olympus'

CMD ["./result/bin/olympus"]
