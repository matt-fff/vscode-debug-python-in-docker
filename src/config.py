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

    @property
    def debug(self) -> bool:
        return self.get_bool("DEBUG", False)

    @property
    def debugger_secret(self) -> str:
        return self.get_value("DEBUGGER_SECRET", None)

config = Config()
