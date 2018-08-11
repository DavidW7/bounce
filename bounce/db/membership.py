"""Defines the schema for the Memberships table in our DB."""

from sqlalchemy import Column, ForeignKey, Integer, func
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.types import TIMESTAMP

Base = declarative_base()  # pylint: disable=invalid-name


'''Create an insert method in bounce/db/membership.py for inserting new users into the DB (see bounce/db/user.py as an example)'''



class Membership(Base):
    """
    Specifies a mapping between a Membership as a Python object and the
    Memberships table in our DB. A memership is simply a mapping from a user
    to a club they're a member of.
    """
    __tablename__ = 'memberships'

    identifier = Column('id', Integer, primary_key=True)
    user_id = Column(
        'user_id', Integer, ForeignKey('user.user_id'), nullable=False, primary_key=True)
    club_id = Column(
        'club_id', Integer, ForeignKey('club.club_id'), nullable=False, primary_key=True)
    created_at = Column(
        'created_at', TIMESTAMP, nullable=False, server_default=func.now())

    def to_dict(self):
        """Returns a dict representation of a Membership."""
        return {
            'id': self.identifier,
            'user_id': self.user_id,
            'club_id': self.club_id,
            'created_at': self.created_at,
        }


def insert(session, user_id, club_id):
    """Insert a new user into the Users table."""
    membership = Membership(
        user_id=user_id, club_id=club_id)
    session.add(membership)
    session.commit()

def select(session, id):
    """
    Returns the membership with the given id or None if
    there is no such member.
    """
    membership = session.query(Membership).filter(Membership.id == id).first()
    return None if membership is None else membership.to_dict()

def delete(session, id):
    """Deletes the club with the given name."""
    session.query(Membership).filter(Membership.id == id).delete()
    session.commit()
