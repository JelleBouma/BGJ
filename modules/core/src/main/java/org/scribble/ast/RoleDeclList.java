package org.scribble.ast;

import java.util.List;
import java.util.stream.Collectors;

import org.scribble.del.ScribDel;
import org.scribble.sesstype.kind.RoleKind;
import org.scribble.sesstype.name.Role;
import org.scribble.util.ScribUtil;

public class RoleDeclList extends HeaderParamDeclList<RoleKind>
{
	public RoleDeclList(List<RoleDecl> decls)
	{
		super(decls);
	}

	@Override
	protected RoleDeclList copy()
	{
		return new RoleDeclList(getDecls());
	}
	
	@Override
	public RoleDeclList clone()
	{
		List<RoleDecl> decls = ScribUtil.cloneList(getDecls());
		return AstFactoryImpl.FACTORY.RoleDeclList(decls);
	}

	@Override
	public HeaderParamDeclList<RoleKind> reconstruct(List<? extends HeaderParamDecl<RoleKind>> decls)
	{
		ScribDel del = del();
		RoleDeclList rdl = new RoleDeclList(castRoleDecls(decls));
		rdl = (RoleDeclList) rdl.del(del);
		return rdl;
	}
	
	@Override
	public List<RoleDecl> getDecls()
	{
		return castRoleDecls(super.getDecls());
	}

	public List<Role> getRoles()
	{
		return getDecls().stream().map((decl) -> decl.getDeclName()).collect(Collectors.toList());
	}

	// Move to del?
	@Override
	public RoleDeclList project(Role self)
	{
		return AstFactoryImpl.FACTORY.RoleDeclList(getDecls());
	}

	@Override
	public String toString()
	{
		return "(" + super.toString() + ")";
	}
	
	private static List<RoleDecl> castRoleDecls(List<? extends HeaderParamDecl<RoleKind>> decls)
	{
		return decls.stream().map((d) -> (RoleDecl) d).collect(Collectors.toList());
	}
}
