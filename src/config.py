"""
Container for Config
"""
import os
import logging

logger = logging.getLogger(__name__)


class Config(object):
    """
    Extracts config information from environmental variables
    """

    def get_value(self, variable: str, default=None):
        """
        Returns the environment variable, if it's defined.
        Returns the default, otherwise
        """
        if variable in os.environ:
            return os.environ[variable]

        return default

    def get_bool(self, variable: str, default: bool) -> bool:
        return "{}".format(self.get_value(variable, default)).lower() == "true"

    def get_int(self, variable: str, default: int) -> int:
        return int(self.get_value(variable, default))

    @property
    def debug(self) -> bool:
        return self.get_bool("DEBUG", False)

    @property
    def debug_port(self) -> str:
        return self.get_int("DEBUG_PORT", 3000)

    @property
    def debug_secret(self) -> str:
        return self.get_value("DEBUG_SECRET", None)


config = Config()
