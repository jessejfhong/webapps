FROM ghcr.io/jessejfhong/rust:latest AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json


FROM ghcr.io/jessejfhong/rust:latest AS builder
COPY --from=planner /home/rust/recipe.json recipe.json
RUN cargo chef cook --release --target x86_64-unknown-linux-musl --recipe-path recipe.json
COPY . .
RUN cargo build --release --target x86_64-unknown-linux-musl --bin webserver


FROM alpine:latest AS runtime
RUN addgroup -S rust; \
    adduser -S rust -G rust; \
    apk add --update-cache
WORKDIR /home/rust
COPY --chown=rust:rust \
     --from=builder /home/rust/target/x86_64-unknown-linux-musl/release/webserver webserver
EXPOSE 8080
USER rust
ENTRYPOINT ["./webserver"]
