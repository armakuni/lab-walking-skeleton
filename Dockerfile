FROM rustlang/rust:nightly as builder
WORKDIR /usr/src
RUN cargo new lab-walking-skeleton --bin
WORKDIR /usr/src/lab-walking-skeleton
COPY Cargo.* ./
RUN cargo run
COPY . .
RUN cargo install --path .

FROM debian:buster-slim
COPY --from=builder /usr/local/cargo/bin/lab-walking-skeleton /usr/local/bin/lab-walking-skeleton

ENV ROCKET_ENV=production
CMD ["lab-walking-skeleton"]