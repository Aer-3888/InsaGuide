package fr.insarennes.model;

import com.google.common.base.MoreObjects;
import java.util.HashSet;
import java.util.Set;

public class Agenda extends CalendarElement {
	private String name;
	private final Set<Cours> cours;
	private final Set<Enseignant> enseignants;
	private final Set<Matiere> matieres;

	/**
	 * Creates the agenda with a name and an empty set of courses, teachers, and topics.
	 */
	public Agenda() {
		super();
		name = "myAgenda";
		cours = new HashSet<>();
		enseignants = new HashSet<>();
		matieres = new HashSet<>();
	}

	/**
	 * @return The name of the calendar.
	 */
	public String getName() {
		return name;
	}

	/**
	 * Sets the name of the calendar.
	 * @param name The new name. Nothing is done is null.
	 */
	public void setName(final String name) {
		if(name != null) {
			this.name = name;
		}
	}

	/**
	 * Adds a course to the calendar.
	 * @param c The course to add. Nothing is done if null.
	 */
	public void addCours(final Cours c) {
		if(c != null) {
			cours.add(c);
		}
	}

	public void addEnseignant(final Enseignant ens) throws IllegalArgumentException {
		if(enseignants.stream().anyMatch(ens2 -> ens.getName().equals(ens2.getName()))) {
			throw new IllegalArgumentException("Two teachers cannot have the same name");
		}
		enseignants.add(ens);
	}

	public void addMatiere(final Matiere mat) throws IllegalArgumentException {
		if(matieres.stream().anyMatch(mat2 -> mat.getName().equals(mat2.getName()) || mat.getAnnee() == mat2.getAnnee())) {
			throw new IllegalArgumentException("Two subjects of the same year cannot have the same name");
		}
		matieres.add(mat);
	}

	public boolean delMatiere(final int id) throws IllegalArgumentException {
		final Matiere mat = this.getMatiere(id);
		if (mat == null)
			return false;
		matieres.remove(mat);
		return true;
	}

	public Matiere getMatiere(final int id) {
		for (Matiere mat : this.matieres) {
			if (mat.getId() == id) {
				return mat;
			}
		}
		return null;
	}

	public Set<Cours> getCours() {
		return cours;
	}

	public Set<Enseignant> getEnseignants() {
		return enseignants;
	}

	public Enseignant getEnseignantById(final int id) {
		for (Enseignant e : this.enseignants) {
			if (e.id == id)
				return e;
		}
		return null;
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("name", name).add("cours", cours).add("id", id).toString();
	}

//	@Override
//	public boolean equals(final Object o) {
//		if(this == o) {
//			return true;
//		}
//		if(!(o instanceof Agenda)) {
//			return false;
//		}
//		final Agenda agenda = (Agenda) o;
//		return Objects.equals(getName(), agenda.getName()) && getCours().equals(agenda.getCours());
//	}
//
//	@Override
//	public int hashCode() {
//		return Objects.hash(getName(), getCours());
//	}
}
