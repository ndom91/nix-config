return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        targetDir = ".rust-analyzer/target",
      },
      check = {
        command = "clippy",
        allTargets = true,
        features = "all",
        extraArgs = {
          "--target-dir .rust-analyzer/target",
        },
      },
    },
  },
}
