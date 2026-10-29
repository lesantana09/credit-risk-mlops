from pathlib import Path

import pytest

from credit_risk.config import Settings, get_settings


def test_defaults_point_to_local_environment() -> None:
    settings = Settings()

    assert settings.environment == "local"
    assert settings.random_seed == 42


def test_data_subdirectories_derive_from_data_dir(tmp_path: Path) -> None:
    settings = Settings(data_dir=tmp_path)

    assert settings.raw_dir == tmp_path / "raw"
    assert settings.processed_dir == tmp_path / "processed"


def test_environment_variables_override_defaults(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("CREDIT_RISK_ENVIRONMENT", "prod")
    monkeypatch.setenv("CREDIT_RISK_RANDOM_SEED", "7")

    settings = Settings()

    assert settings.environment == "prod"
    assert settings.random_seed == 7


def test_invalid_environment_is_rejected(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("CREDIT_RISK_ENVIRONMENT", "staging")

    with pytest.raises(ValueError, match="environment"):
        Settings()


def test_get_settings_is_cached() -> None:
    assert get_settings() is get_settings()
